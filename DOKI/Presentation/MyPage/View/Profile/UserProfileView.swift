//
//  UserProfileView.swift
//  DOKI
//
//  Created by 안치욱 on 12/30/25.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var viewModel: UserProfileViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 16)
            
            nickname
            
            Spacer().frame(height: 16)
            
            birth
            
            Spacer().frame(height: 16)
            
            selectGender
            
            Spacer()
            
            MainButton(
                text: "저장하기",
                buttonState: viewModel.buttonDisabled ? .disabled : .active1,
                action: viewModel.saveButtonTapped
            )
        }
        .padding(.horizontal, 16)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .topNavigationView(left: {
            BackButton(action: {
                dismiss()
            })
        }, center: {
            Text("내 정보 수정")
                .subtitle()
        })
        .onChange(of: viewModel.isSaveCompleted) { _, completed in
            if completed {
                dismiss()
            }
        }
    }
}

extension UserProfileView {
    private var nickname: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 0) {
                Text("닉네임").bodyActive()
                
                Spacer()
                
                Text(viewModel.nicknameMessage)
                    .font(.small)
                    .foregroundColor(.defaultRed)
            }
            
            MainTextField(
                placeholder: "최대 8글자 이내로 입력해주세요",
                text: $viewModel.nickname,
                isError: viewModel.isNicknameAvailable == false
            )
            .onChange(of: viewModel.nickname) { _, newValue in
                if newValue.count > 8 {
                    viewModel.nickname = String(newValue.prefix(8))
                }
            }
        }
    }
    
    private var birth: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("생년월일").bodyActive()
            
            MainTextField(
                placeholder: "YYYY/MM/DD",
                text: $viewModel.birthDay
            )
            .keyboardType(.numberPad)
            .onChange(of: viewModel.birthDay) { old, new in
                guard new.count >= old.count else { return }
                
                let formatted = new.formattedBirthDate()
                if formatted != new {
                    viewModel.birthDay = formatted
                }
            }
        }
    }
    
    private var selectGender: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("성별").bodyActive()
            
            HStack(spacing: 4) {
                ForEach(Gender.allCases) { gender in
                    GenderSelectButton(
                        text: gender.rawValue,
                        isChecked: viewModel.gender == gender
                    ) {
                        viewModel.selecteGender(gender)
                    }
                }
            }
        }
    }
}
