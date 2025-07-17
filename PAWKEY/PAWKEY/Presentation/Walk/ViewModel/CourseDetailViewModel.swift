//
//  CourseDetailViewModel.swift
//  PAWKEY
//
//  Created by 이세민 on 7/9/25.
//

import SwiftUI

import Moya

class CourseDetailViewModel: ObservableObject, Hashable {
    static func == (lhs: CourseDetailViewModel, rhs: CourseDetailViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let provider = MoyaProvider<WalkPostAPI>(plugins: [MoyaLoggingPlugin()])
    
    let postId: Int
    let id = UUID()
    
    @Published var images: [UIImage] = []
    @Published var isPrivate: Bool = false
    @Published var selectedImage: UIImage?
    @Published var isShowPhotoPreview = false
    @Published var isShowContextMenu = false
    @Published var isShowSharedWalkCourseView = false
    @Published var topReviews: [CategoryTop] = []
    @Published var reviewCount: Int = 0
    
    @Published var post: Post?
    
    init(postId: Int) {
        self.postId = postId
    }
    
    @MainActor
    func fetchCoruseDetail() async {
        do {
            let response: BaseDTO<PostResponseDTO> = try await provider.async.request(.fetchPostDetail(postId: postId))
            
            guard let data = response.data else {
                return
            }
            self.post = data.toEntity()
        } catch {
            print("에러 발생: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchReviewsTop() async {
        guard let routeId = post?.routeId else { return }
        do {
            let response: BaseDTO<WalkPostReviewDTO> = try await provider.async.request(.fetchReviewsTop(routeId: routeId))
            
            guard let data = response.data else {
                return
            }
            topReviews = data.toEntity().categoryTop3
            
            self.reviewCount = data.toEntity().totalReviewCount
            
            print(reviewCount)
        } catch {
            print("에러 발생: \(error.localizedDescription)")
        }
    }
    func likePost() async {
        let provider = MoyaProvider<LikePostAPI>(plugins: [MoyaLoggingPlugin()])
        
        do {
            let response: BaseDTO<PostResponseDTO> = try await provider.async.request(.postLike(postId: postId))
        } catch {
            print("에러 발생: \(error.localizedDescription)")
        }
    }
    
    
    func unLikePost() async {
        let provider = MoyaProvider<LikePostAPI>(plugins: [MoyaLoggingPlugin()])
        do {
        
            let response: BaseDTO<PostResponseDTO> = try await provider.async.request(.deleteLike(postId: postId))
        } catch {
            print("에러 발생: \(error.localizedDescription)")
        }
    }
}
