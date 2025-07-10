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
                
                // TODO: head24로 변경
                Text("견주님에 대해 알려주세요.")
                    .font(.head_22_sb)
                    .foregroundStyle(.pawkeyBlack)
                
                Spacer().frame(height: 42)
                
                VStack(alignment:.leading) {
                    Text("이름")
                        .font(.body_14_sb)
                    PKTextField(text: $viewModel.userProfile.userName)
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading) {
                    Text("성별")
                        .font(.body_14_sb)
                    HStack {
                        ForEach(viewModel.genderList, id: \.self) { gender in
                            ChoiceButton(gender, isSelected: gender == viewModel.userProfile.userGender) { gender in
                                viewModel.changeUserInfo(.userGender(gender))
                            }
                        }
                    }
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading) {
                    Text("나이")
                        .font(.body_14_sb)
                    PKTextField(text: $viewModel.userProfile.userAge, type: .number)
                }
                
                Spacer()
            }
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            .padding(.horizontal, 16)
        }
    }
}
