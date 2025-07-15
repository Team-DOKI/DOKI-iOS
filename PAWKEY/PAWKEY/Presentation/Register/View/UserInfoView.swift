//
//  UserInfoView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI

struct UserInfoView: View {
    @ObservedObject var viewModel: ProfileSetUpViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                
                Spacer().frame(height: 20)
                                
                Text("견주님에 대해 알려주세요.")
                    .font(.head_24_sb)
                    .foregroundStyle(.pawkeyBlack)
                
                Spacer().frame(height: 42)
                
                VStack(alignment:.leading) {
                    Text("이름")
                        .font(.body_14_sb)
                    PawkeyTextField(text: $viewModel.userProfile.name,
                                placeholder: "이름을 입력해주세요.")
                }
                                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading) {
                    Text("성별")
                        .font(.body_14_sb)
                    HStack {
                        ForEach(viewModel.genderList, id: \.self) { gender in
                            LocationButton(gender, isSelected: gender == viewModel.userProfile.gender) { gender in
                                viewModel.changeUserInfo(.userGender(gender))
                            }
                        }
                    }
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading) {
                    Text("나이")
                        .font(.body_14_sb)
                    PawkeyTextField(text: $viewModel.userProfile.age,
                                placeholder: "나이를 입력해주세요.", type: .number)
                }
                
                Spacer()
            }          
            .padding(.horizontal, 16)        
        }
    }
}
