//
//  MyCourseViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import Foundation

import Moya


final class MyCourseViewModel: ObservableObject {
    @Published var myCourses: [MyCourse] = []

    private let provider = MoyaProvider<MyCourseAPI>()

    func fetchMyCourses() async {
        do {
            let response: BaseDTO<MyCourseListDTO> = try await provider.async.request(.getMyCourse)

            guard let data = response.data else {
                print("데이터 없음")
                return
            }
            DispatchQueue.main.async {
                self.myCourses = data.posts.map { MyCourse(dto: $0) }
                print("나의 산책 코스 개수: \(self.myCourses)")
            }
        } catch {
            print("나의 산책 코스 불러오기 실패: \(error.localizedDescription)")
        }
    }
}
