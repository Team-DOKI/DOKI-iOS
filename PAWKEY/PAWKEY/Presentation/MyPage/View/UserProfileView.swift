//
//  UserProfileView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var coordinator: Coordinator<MyPageScene>
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    
    @StateObject var viewModel: UserProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let user = viewModel.userProfile {
                // 이름
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("이름")
                            .font(.body_14_m)
                            .padding(.leading, 16)
                        Spacer()
                    }
                    HStack {
                        Text(user.name)
                            .font(.head_18_sb)
                            .foregroundStyle(Color.green500)
                            .padding(.leading, 16)
                    }
                }
                
                // 성별
                VStack(alignment: .leading, spacing: 10) {
                    Text("성별")
                        .font(.body_14_m)
                        .padding(.leading, 16)
                    //Text(user.gender)
                    Text(Gender.init(rawValue: user.gender)?.userGenderText ?? "성별 오류")
                        .font(.head_18_sb)
                        .foregroundStyle(Color.green500)
                        .padding(.leading, 16)
                }
                
                // 나이
                VStack(alignment: .leading, spacing: 10) {
                    Text("나이")
                        .font(.body_14_m)
                        .padding(.leading, 16)
                    Text("\(user.age)세")
                        .font(.head_18_sb)
                        .foregroundStyle(Color.green500)
                        .padding(.leading, 16)
                }
                
                // 활동지역
                VStack(alignment: .leading, spacing: 10) {
                    Text("활동지역")
                        .font(.body_14_m)
                        .padding(.leading, 16)
                    Text(user.region)
                        .font(.head_18_sb)
                        .foregroundStyle(Color.green500)
                        .padding(.leading, 16)
                }
                
                Spacer()
            }
            
        }
        .navigationBarBackButtonHidden()
        .topNavigationView(left: {
            BackButton {
                coordinator.pop()
                mainTabViewModel.isHidden = false
            }
        }, center: {
            Text("견주 프로필")
                .font(.body_16_sb)
        })
        .onAppear {
            Task {
                await viewModel.fetchUserProfile()
            }
        }
        
    }
}
