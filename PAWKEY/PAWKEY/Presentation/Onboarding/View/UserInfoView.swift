//
//  UserInfoView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI

struct UserInfoView: View {
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
                    PKTextField(text: .constant(""))
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading) {
                    Text("성별")
                        .font(.body_14_sb)
                    HStack {
                        ChoiceButton("남성")
                        ChoiceButton("여자")
                    }
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading) {
                    Text("나이")
                        .font(.body_14_sb)
                    PKTextField(text: .constant(""))
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

#Preview {
    UserInfoView()
}
