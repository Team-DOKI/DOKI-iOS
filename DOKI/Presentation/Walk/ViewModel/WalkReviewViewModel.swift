//
//  WalkReviewViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

class WalkReviewViewModel: ObservableObject {
    
    private let routeAPIService: RouteAPIServiceProtocol = RouteAPIService()
    private let filterAPIServie: FilterAPIService
    private let postAPIService: PostAPIService
    private let imageAPIService: ImageAPIServiceProtocol
    
    var navigationAction: ((WalkReviewRoute)->())?
    var selectedFilterOptions: [FilterList] = []
    
    @Published var isShowReviewCompleted: Bool = false
    private var uploadedPostId: Int = 0
    
    // 산책 게시물 제목
    @Published var title: String = ""
    
    // 산책 게시물 내용
    @Published var description: String = ""
    @Published var address: String = "상세 주소"
    @Published var recordDate: String = "YY.MM.DD | 오후 00:00"
    @Published var walkRecord: String = "거리 | 시간 | 걸음수"
    
    
    @Published var walkImages: [UIImage] = []
    @Published var walkImageIds: [Int] = []
    @Published var routeImage: UIImage = UIImage(resource: .imgUpperbodydog)
    
    @Published var selectedCongestion: FilteringOption?
    @Published var selectedExchange: FilteringOption?
    
    @Published var safety: [FilteringOption] = []
    
    @Published var convenience: [FilteringOption] = []
    
    @Published var environment: [FilteringOption] = []
    
    @Published var congestion: [FilteringOption] = []
    
    @Published var exchange: [FilteringOption] = []
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
    
    init(
        filterAPIService: FilterAPIService,
        postAPIService: PostAPIService,
        imageAPIService: ImageAPIService
    ) {
        self.filterAPIServie = filterAPIService
        self.postAPIService = postAPIService
        self.imageAPIService = imageAPIService
    }
    
    func navigateBackToRoot() {
        navigationAction?(.backToRoot)
    }
    
    func navigateToDetail() {
        navigationAction?(.routeDetail(postId: uploadedPostId))
    }
    
    func showReviewComplete() {
        isShowReviewCompleted = true
    }

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
                        walkImages.append(image)
                        walkImageIds.append(imageId)
                    }
                }
            } catch {
                print("산책 이미지 업로드 실패:", error.localizedDescription)
            }
        }
    }
}

extension WalkReviewViewModel {
    func bindData() {
        selectedFilterOptions.forEach {
            switch $0.filterType {
            case .congestion:
                self.congestion = $0.options
                if let selectedCongestion = $0.options.first(where: { $0.isActive }) { self.selectedCongestion = selectedCongestion }
            case .exchange:
                self.exchange = $0.options
                if let selectedExchange = $0.options.first(where: { $0.isActive }) { self.selectedExchange = selectedExchange }
            case .safety:
                self.safety = $0.options
            case .convenience:
                self.convenience = $0.options
            case .environment:
                self.environment = $0.options
            default:
                break
            }
        }
    }
}

extension WalkReviewViewModel {
    func fetchWalkSummary() {
        
        guard let routeId = WalkSessionManager.shared.nRouteId else { return }
        
        routeAPIService.fetchWalkSummary(routeId: routeId) { [weak self] result in
            switch result {
            case .success(let response):
                guard
                    let data = response?.data?.routeDisplay
                else { return }
                
                DispatchQueue.main.async {
                    self?.address = data.locationText
                    self?.recordDate = data.dateTimeText
                    self?.walkRecord = data.metaTagTexts.joined(separator: " | ")
                }
                
            default:
                print("산책 요약 정보 조회에 실패했습니다.")
            }
        }
    }
    
    @MainActor
    func fetchFilterCategories() async {
        if !selectedFilterOptions.isEmpty { return }
        
        do {
            let response = try await filterAPIServie.fetchFilterCategories()
            selectedFilterOptions = response
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func uploadPost(isPublic: Bool) {
        Task {
            await MainActor.run {
                loadingStatus = .loading
                tappedButton = isPublic
            }
            do {
                let selectedOptionsForCategories = createSelectedOptions(selectedOption: selectedFilterOptions)

                guard let nRouteId = WalkSessionManager.shared.nRouteId else {
                    await MainActor.run { loadingStatus = .failed("산책 루트 ID가 없습니다.") }
                    return
                }

                let routeImageId = WalkSessionManager.shared.routeImageId ?? 0

                let request = PostRegisterRequest(
                    title: title,
                    description: description,
                    isPublic: isPublic,
                    selectedOptionsForCategories: selectedOptionsForCategories,
                    routeId: nRouteId,
                    routeImageId: routeImageId,
                    walkImageIds: walkImageIds
                )
                                               
                let response = try await postAPIService.uploadPost(request: request)

                await MainActor.run {
                    uploadedPostId = response.data?.postId ?? 0
                    loadingStatus = .success
                    tappedButton = nil
                    showReviewComplete()
                }
            } catch {
                await MainActor.run {
                    loadingStatus = .failed(error.localizedDescription)
                    tappedButton = nil
                }
            }
        }
    }
    
    private func createSelectedOptions(selectedOption: [FilterList]) -> [SelectedOption] {
        var selectedOption: [FilterList] = selectedOption

        for index in selectedOption.indices {
            switch selectedOption[index].filterType {
            // 단일 선택
            case .congestion:
                selectedOption[index].options.reset()
                if let selectedCongestion,
                   let optionIndex = selectedOption[index].options.firstIndex(where: { $0.id == selectedCongestion.id }) {
                    selectedOption[index].options[optionIndex].isActive = true
                }
            case .exchange:
                selectedOption[index].options.reset()
                if let selectedExchange,
                    let optionIndex = selectedOption[index].options.firstIndex(where: { $0.id == selectedExchange.id }) {
                    selectedOption[index].options[optionIndex].isActive = true
                }
            // 중복 선택
            case .safety:
                selectedOption[index].options = safety
            case .convenience:
                selectedOption[index].options = convenience
            case .environment:
                selectedOption[index].options = environment
            default:
                break
            }
        }

        let selectedOptionsForCategories = selectedOption.map {
            SelectedOption(
                categoryId: $0.id,
                selectedOptionIds: $0.options.filter { $0.isActive}.map { $0.id }
            )
        }
        
        return selectedOptionsForCategories
    }
    
    private func uploadToS3(url: URL, data: Data) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        do {
           let _ = try await URLSession.shared.data(for: request)
        } catch {
            throw error
        }
    }
}
