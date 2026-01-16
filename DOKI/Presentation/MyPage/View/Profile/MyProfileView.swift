//
//  MyProfileView.swift
//  DOKI
//
//  Created by 안치욱 on 12/30/25.
//

import SwiftUI

struct MyProfileView: View {
    @ObservedObject var viewModel: MyProfileViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 16)
            
            nickname
            
            Spacer().frame(height: 16)
            
            birth
            
            Spacer().frame(height: 16)
            
            selecteGender
            
            Spacer()
            
            MainButton(
                text: "저장하기",
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
    }
}

extension MyProfileView {
    private var nickname: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("닉네임").bodyActive()
            
            MainTextField(
                placeholder: "최대 8글자 이내로 입력해주세요",
                text: $viewModel.nickname
            )
        }
    }
    
    private var birth: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("생년월일").bodyActive()
            
            MainTextField(
                placeholder: "YYYY/MM/DD",
                text: $viewModel.birthDay
            )
        }
    }
    
    private var selecteGender: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("성별").bodyActive()
            
            HStack(spacing: 4) {
                ForEach(Gender.allCases) { gender in
                    CheckBox(
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
