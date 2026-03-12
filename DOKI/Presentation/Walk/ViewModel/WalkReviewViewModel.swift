//
//  WalkReviewViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

// TODO: routeImage -> 임시 이미지로 대체

class WalkReviewViewModel: ObservableObject {
    private let routeAPIService: RouteAPIServiceProtocol = RouteAPIService()
    private let filterAPIServie: FilterAPIService
    private let postAPIService: PostAPIService
    private let imageAPIService: ImageAPIServiceProtocol
    
    var navigationAction: ((WalkReviewRoute)->())?
    var selectedFilterOptions: [FilterList] = []
    
    @Published var isShowReviewCompleted: Bool = false
    
    // 산책 게시물 제목
    @Published var title: String = ""
    
    // 산책 게시물 내용
    @Published var description: String = ""
    @Published var address: String = "상세 주소"
    @Published var recordDate: String = "YY.MM.DD | 오후 00:00"
    @Published var walkRecord: String = "거리 | 시간 | 걸음수"
    
    
    @Published var walkImages: [UIImage] = []
    @Published var routeImage: UIImage = UIImage(resource: .imgUpperbodydog)
    
    @Published var selectedCongestion: FilteringOption?
    @Published var selectedExchange: FilteringOption?
    
    @Published var safety: [FilteringOption] = []
    
    @Published var convenience: [FilteringOption] = []
    
    @Published var environment: [FilteringOption] = []
    
    @Published var congestion: [FilteringOption] = []
    
    @Published var exchange: [FilteringOption] = []

    
    private var routeId = 0
    private var routeImageId = 0
    private var walkImageIds: [Int] = []
    
    init(filterAPIService: FilterAPIService, postAPIService: PostAPIService, imageAPIService: ImageAPIService) {
        self.filterAPIServie = filterAPIService
        self.postAPIService = postAPIService
        self.imageAPIService = imageAPIService
    }
    
    func navigateBackToRoot() {
        navigationAction?(.backToRoot)
    }
    
    func navigateToDetail() {
        navigationAction?(.routeDetail)
    }
    
    func showReviewComplete() {
        isShowReviewCompleted = true
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
            selectedCongestion = selectedFilterOptions.filter { $0.filterType == .congestion }.flatMap { $0.options }[0]
            selectedExchange = selectedFilterOptions.filter { $0.filterType == .exchange }.flatMap { $0.options }[0]
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func uploadPost(isPublic: Bool) {
        Task {
            do {
                // 필터 데이터 처리
                var selectedOption: [FilterList] = selectedFilterOptions

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
                

                let selectedOptionsForCategories = selectedOption.map { SelectedOption(categoryId: $0.id, selectedOptionIds: $0.options.filter {$0.isActive}.map { $0.id}) }
                
                // 경로 이미지 등록
                let presignedURLRequest = PresignedURLRequest(
                    domain: "PET_PROFILE",
                    contentType: "image/jpeg"
                )
                
                guard let routeCgImage = routeImage.cgImage,
                      let routeImageData = UIImage(cgImage: routeCgImage).jpegData(compressionQuality: 0.8) else { return }
                
                // presignedURL 요청
                imageAPIService.presignedURL(request: presignedURLRequest) { [weak self] result in
                    
                    switch result {
                    case .success(let response):
                        guard let data = response?.data, let uploadURL = URL(string: data.uploadUrl) else { return }
                        
                        self?.uploadToS3(url: uploadURL, data: routeImageData) { [weak self] isSuccess in
                            guard let self else { return }
                            let routeImageRequest = RegisterImageRequest(
                                imageUrl: data.imageUrl,
                                contentType: "image/jpeg",
                                width: Int(routeImage.size.width),
                                height: Int(routeImage.size.height),
                                domain: "PET_PROFILE"
                            )
                                                        
                            imageAPIService.registerImage(request: routeImageRequest) { [weak self] result in
                                switch result {
                                case let .success(response):
                                    guard let data = response?.data else { return }
                                    self?.routeImageId = data.imageId
                                default:
                                    print("Route Image 등록 실패")
                                }
                            }
                        }
                        
                    default:
                        print("presignedURL 오류")
                    }
                }                
                
                // 산책 이미지 등록
                walkImages.forEach { walkImage in
                
                    guard let cgImage = walkImage.cgImage,
                    let imageData = UIImage(cgImage: cgImage).jpegData(compressionQuality: 0.8) else { return }
                    
                    imageAPIService.presignedURL(request: presignedURLRequest) { [weak self] result in
                        switch result {
                        case .success(let response):
                            guard let data = response?.data, let uploadURL = URL(string: data.uploadUrl) else { return }
                            
                            self?.uploadToS3(url: uploadURL, data: imageData) { [weak self] isSuccess in
                                guard let self else { return }
                                let imageRequest = RegisterImageRequest(
                                    imageUrl: data.imageUrl,
                                    contentType: "image/jpeg",
                                    width: Int(walkImage.size.width),
                                    height: Int(walkImage.size.height),
                                    domain: "PET_PROFILE"
                                )
                                                            
                                imageAPIService.registerImage(request: imageRequest) { [weak self] result in
                                    guard let self else { return }
                                    switch result {
                                    case let .success(response):
                                        guard let data = response?.data else { return }
                                        walkImageIds.append(data.imageId)
                                        
                                        let request = PostRegisterRequest(
                                            title: title,
                                            description: description,
                                            isPublic: isPublic,
                                            selectedOptionsForCategories: selectedOptionsForCategories,
                                            routeId: routeId,
                                            routeImageId: routeImageId,
                                            walkImageIds: walkImageIds
                                        )
                                        
                                        postAPIService.uploadPost(isPublic: isPublic, request: request)
                                    default:
                                        print("Route Image 등록 실패")
                                    }
                                }
                            }
                            
                        default:
                            print("presignedURL 등록 실패")
                        }
                    }
                }
                                                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func uploadToS3(url: URL, data: Data, completion: @escaping (Bool) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse,
               200..<300 ~= httpResponse.statusCode {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}
