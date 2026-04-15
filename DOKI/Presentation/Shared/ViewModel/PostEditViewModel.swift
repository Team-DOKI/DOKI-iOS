//
//  PostEditViewModel.swift
//  DOKI
//

import SwiftUI

class PostEditViewModel: ObservableObject {

    // MARK: - Walk Info
    @Published var address: String
    @Published var recordDate: String
    @Published var walkRecord: String

    // MARK: - Review
    @Published var title: String
    @Published var description: String

    // MARK: - Images
    @Published var existingImageURLs: [String]
    @Published var newWalkImages: [UIImage] = []
    private(set) var existingWalkImageIds: [Int]
    private var newWalkImageIds: [Int] = []

    var totalImageCount: Int { existingImageURLs.count + newWalkImages.count }

    // MARK: - Filter Categories
    @Published var selectedCongestion: FilteringOption?
    @Published var selectedExchange: FilteringOption?
    @Published var congestion: [FilteringOption] = []
    @Published var exchange: [FilteringOption] = []
    @Published var safety: [FilteringOption] = []
    @Published var convenience: [FilteringOption] = []
    @Published var environment: [FilteringOption] = []

    @Published var loadingStatus: LoadingStatus = .ready
    @Published var tappedButton: Bool? = nil  // false = 나만보기, true = 공유하기

    var isFormValid: Bool {
        selectedCongestion != nil &&
        selectedExchange != nil &&
        safety.contains(where: { $0.isActive }) &&
        convenience.contains(where: { $0.isActive }) &&
        environment.contains(where: { $0.isActive }) &&
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var selectedFilterOptions: [FilterList] = []
    private let postAPIService: PostAPIServiceProtocol
    private let filterAPIService: FilterAPIService
    private let imageAPIService: ImageAPIServiceProtocol
    private let postId: Int
    private let rawCategoryTexts: [String]

    init(
        postAPIService: PostAPIServiceProtocol,
        imageAPIService: ImageAPIServiceProtocol,
        postId: Int,
        rawWalkImages: [PostDetailResponse.WalkImage],
        rawCategoryTexts: [String],
        initialTitle: String,
        initialDescription: String,
        initialAddress: String,
        initialRecordDate: String,
        initialWalkRecord: String
    ) {
        self.postAPIService = postAPIService
        self.imageAPIService = imageAPIService
        self.filterAPIService = FilterAPIService()
        self.postId = postId
        self.rawCategoryTexts = rawCategoryTexts
        self.title = initialTitle
        self.description = initialDescription
        self.address = initialAddress
        self.recordDate = initialRecordDate
        self.walkRecord = initialWalkRecord
        self.existingImageURLs = rawWalkImages.map { $0.imageUrl }
        self.existingWalkImageIds = rawWalkImages.map { $0.imageId }
    }

    // MARK: - Filter Categories

    @MainActor
    func fetchFilterCategories() async {
        guard selectedFilterOptions.isEmpty else { return }
        do {
            selectedFilterOptions = try await filterAPIService.fetchFilterCategories()
            preSelectFilters()
        } catch {
            print("필터 카테고리 조회 실패:", error.localizedDescription)
        }
    }

    private func preSelectFilters() {
        for index in selectedFilterOptions.indices {
            switch selectedFilterOptions[index].filterType {
            case .congestion:
                congestion = selectedFilterOptions[index].options
                selectedCongestion = congestion.first { rawCategoryTexts.contains($0.text) }
            case .exchange:
                exchange = selectedFilterOptions[index].options
                selectedExchange = exchange.first { rawCategoryTexts.contains($0.text) }
            case .safety:
                for i in selectedFilterOptions[index].options.indices {
                    selectedFilterOptions[index].options[i].isActive = rawCategoryTexts.contains(selectedFilterOptions[index].options[i].text)
                }
                safety = selectedFilterOptions[index].options
            case .convenience:
                for i in selectedFilterOptions[index].options.indices {
                    selectedFilterOptions[index].options[i].isActive = rawCategoryTexts.contains(selectedFilterOptions[index].options[i].text)
                }
                convenience = selectedFilterOptions[index].options
            case .environment:
                for i in selectedFilterOptions[index].options.indices {
                    selectedFilterOptions[index].options[i].isActive = rawCategoryTexts.contains(selectedFilterOptions[index].options[i].text)
                }
                environment = selectedFilterOptions[index].options
            default:
                break
            }
        }
    }

    // MARK: - Image Remove

    func removeExistingImage(at index: Int) {
        guard existingImageURLs.indices.contains(index) else { return }
        existingImageURLs.remove(at: index)
        existingWalkImageIds.remove(at: index)
    }

    func removeNewImage(at index: Int) {
        guard newWalkImages.indices.contains(index) else { return }
        newWalkImages.remove(at: index)
        newWalkImageIds.remove(at: index)
    }

    // MARK: - Image Upload

    func uploadWalkImage(_ image: UIImage) {
        Task {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            do {
                let presignedURLRequest = PresignedURLRequest(domain: "WALK", contentType: "image/jpeg")
                guard let presignedData = try await imageAPIService.asyncPresignedURL(request: presignedURLRequest).data,
                      let uploadURL = URL(string: presignedData.uploadUrl) else { return }

                try await uploadToS3(url: uploadURL, data: imageData)

                let imageRequest = RegisterImageRequest(
                    imageUrl: presignedData.imageUrl,
                    contentType: "image/jpeg",
                    width: Int(image.size.width),
                    height: Int(image.size.height),
                    domain: "WALK"
                )

                if let imageId = try await imageAPIService.asyncRegisterImage(request: imageRequest).data?.imageId {
                    await MainActor.run {
                        newWalkImages.append(image)
                        newWalkImageIds.append(imageId)
                    }
                }
            } catch {
                print("이미지 업로드 실패:", error.localizedDescription)
            }
        }
    }

    // MARK: - Update Post

    func updatePost(isPublic: Bool, onSuccess: @escaping () -> Void) {
        Task {
            await MainActor.run {
                loadingStatus = .loading
                tappedButton = isPublic
            }
            do {
                let allImageIds = existingWalkImageIds + newWalkImageIds
                let selectedOptions = buildSelectedOptions()
                let request = PostUpdateRequest(
                    title: title,
                    description: description,
                    walkImageIds: allImageIds,
                    selectedOptionsForCategories: selectedOptions,
                    isPublic: isPublic
                )
                try await postAPIService.updatePost(postId: postId, request: request)
                await MainActor.run {
                    loadingStatus = .success
                    tappedButton = nil
                    onSuccess()
                }
            } catch {
                await MainActor.run {
                    loadingStatus = .failed(error.localizedDescription)
                    tappedButton = nil
                }
            }
        }
    }

    private func buildSelectedOptions() -> [SelectedOption] {
        var options = selectedFilterOptions
        for index in options.indices {
            switch options[index].filterType {
            case .congestion:
                options[index].options.reset()
                if let selected = selectedCongestion,
                   let i = options[index].options.firstIndex(where: { $0.id == selected.id }) {
                    options[index].options[i].isActive = true
                }
            case .exchange:
                options[index].options.reset()
                if let selected = selectedExchange,
                   let i = options[index].options.firstIndex(where: { $0.id == selected.id }) {
                    options[index].options[i].isActive = true
                }
            case .safety:
                options[index].options = safety
            case .convenience:
                options[index].options = convenience
            case .environment:
                options[index].options = environment
            default:
                break
            }
        }
        return options.map {
            SelectedOption(
                categoryId: $0.id,
                selectedOptionIds: $0.options.filter { $0.isActive }.map { $0.id }
            )
        }
    }

    private func uploadToS3(url: URL, data: Data) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        let _ = try await URLSession.shared.data(for: request)
    }
}
