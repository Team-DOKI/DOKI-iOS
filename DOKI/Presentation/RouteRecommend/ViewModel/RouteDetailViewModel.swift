//
//  RouteDetailViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum RouteDetailRoute {
    case back
}

class RouteDetailViewModel: ObservableObject {
    var postID: Int?
    
    var navigationAction: ((RouteDetailRoute)->())?
    
    @Published var title = "            "
    @Published var address: String = "          "
    @Published var petProfileImageURL = "           "
    @Published var recordDate: String = "           "
    @Published var walkRecord: String = "           "
    @Published var tagList: [String] = []
    @Published var isExpanded: Bool = false
    @Published var petName = "          "
    @Published var routeImageURL = "            "
    @Published var description = "          "
    @Published var walkImageUrls: [String] = []
    @Published var isPublic = false
    @Published var isMine = false
    @Published var loadingStatus: LoadingStatus = .ready
    
    private let postAPIService: PostAPIService
    
    init(postAPIService: PostAPIService, postId: Int? = nil) {
        self.postAPIService = postAPIService
        self.postID = postId
    }
        
    
    func navigateToBack() {
        navigationAction?(.back)
        isExpanded = false
    }
    
    @MainActor
    func fetchPost() {
        Task {
            loadingStatus = .loading
            do {
                guard let postID else { return }
                let response = try await postAPIService.fetchPost(postId: postID)
                guard let data = response.data else { return }
                
                address = data.routeDisplay.locationText
                petProfileImageURL = data.authorInfo.petProfileImage
                tagList = data.categoryTagTexts
                walkRecord = data.routeDisplay.metaTagTexts.joined(separator: " | ")
                petName = data.authorInfo.petName
                routeImageURL = data.routeDisplay.routeImageUrl
                recordDate = data.routeDisplay.dateTimeText
                title = data.title
                description = data.description
                walkImageUrls = data.walkImages.map { $0.imageUrl }
                isPublic = data.isPublic
                isMine = data.isMine
                
                loadingStatus = .success
            } catch {
                loadingStatus = .failed(error.localizedDescription)
            }
        }
    }
}
