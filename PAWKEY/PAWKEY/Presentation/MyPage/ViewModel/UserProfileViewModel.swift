//
//  UserProfileViewModel.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/16/25.
//

import Foundation
import Moya

final class UserProfileViewModel: ObservableObject {
    @Published var userProfile: MyUserProfile?

    private let provider = MoyaProvider<UserProfileAPI>()
    
    func fetchUserProfile() async {
        do {
            let response: BaseDTO<MyUserProfileDTO> = try await provider.async.request(.getUserProfile)
            
            guard let data = response.data else {
                print("데이터 없음")
                return
            }

            DispatchQueue.main.async {
                self.userProfile = MyUserProfile(dto: data)
            }
            // print("유저 정보 불러오기 성공: \(data.name)")
            
        } catch {
            print("유저 정보 요청 실패: \(error.localizedDescription)")
        }
    }
}
