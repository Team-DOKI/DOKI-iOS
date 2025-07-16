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
    
    let postId: Int
    let id = UUID()
    
    @Published var images: [UIImage] = []
    @Published var isPrivate: Bool = false
    @Published var selectedImage: UIImage?
    @Published var isShowPhotoPreview = false
    @Published var isShowContextMenu = false
    @Published var isShowSharedWalkCourseView = false
    
    @Published var post: Post?
    
    init(postId: Int) {
        self.postId = postId
    }
    
    @MainActor
    func fetchCoruseDetail() async {
        let provider = MoyaProvider<WalkPostAPI>(plugins: [MoyaLoggingPlugin()])
        
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
