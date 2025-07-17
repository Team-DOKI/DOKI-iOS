//
//  SavedCourseViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import Foundation

import Moya


final class SavedCourseViewModel: ObservableObject {
    @Published var savedCourses: [SavedCourse] = []

    private let provider = MoyaProvider<SavedCourseAPI>()

    func fetchSavedCourses() async {
        do {
            let response: BaseDTO<SavedCourseListDTO> = try await provider.async.request(.getSavedCourse)

            guard let data = response.data else {
                print("데이터 없음")
                return
            }
            DispatchQueue.main.async {
                self.savedCourses = data.posts.map { SavedCourse(dto: $0) }
                print("저장된 산책 코스 개수: \(self.savedCourses)")
            }
        } catch {
            print("저장된 산책 코스 불러오기 실패: \(error.localizedDescription)")
        }
    }
    
    @MainActor
        func toggleLike(for postId: Int) async {
            guard let index = savedCourses.firstIndex(where: { $0.id == postId }) else {
                print("해당 postId를 가진 코스를 찾을 수 없습니다: \(postId)")
                return
            }
            
            let originalState = savedCourses[index].isLiked
            savedCourses[index].isLiked.toggle() 
            
            let provider = MoyaProvider<LikePostAPI>(plugins: [MoyaLoggingPlugin()])
            
            do {
                if savedCourses[index].isLiked {
                    let response: BaseDTO<PostResponseDTO> = try await provider.async.request(.postLike(postId: postId))
                } else {
                    let response: BaseDTO<PostResponseDTO> = try await provider.async.request(.deleteLike(postId: postId))
                }
            } catch {
                savedCourses[index].isLiked = originalState
                print("에러 발생: \(error.localizedDescription)")
            }
        }
}
