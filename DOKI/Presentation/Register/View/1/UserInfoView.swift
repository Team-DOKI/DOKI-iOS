//
//  UserInfoView.swift
//  DOKI
//
//  Created by a on 10/31/25.
//

import SwiftUI

struct UserInfoView: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 20)
            
            infoTitleView
            
            Spacer().frame(height: 40)
            
            nickname
            
            Spacer().frame(height: 16)
            
            birth
            
            Spacer().frame(height: 16)
            
            selectGender
        }
        .padding(.horizontal, 16)
    }
}

extension UserInfoView {
    private var infoTitleView: some View {
        VStack(spacing: 4) {
            Text("산책하기 전\n간단한 정보를 입력해주세요").header2()
            
            Text("서비스 시작을 위해 간단한 정보를 입력해주세요!")
                .bodyDefault(color: .defaultMiddle)
        }
    }
    
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
                text: $viewModel.nickname
            ).onChange(of: viewModel.nickname) { _, newValue in
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
