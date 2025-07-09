//
//  DogInfoView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI

struct DogInfoView: View {
    @State var profileImage: Image?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                
                Spacer().frame(height: 20)
                
                Text("견주님의 반려견이 궁금해요!")
                    .font(.head_22_sb)
                    .foregroundStyle(.pawkeyBlack)
                    .frame(alignment: .center)
                
                Spacer().frame(height: 32)
                
                HStack {
                    Spacer()
                    Circle()
                        .frame(width: 108, height: 108)
                        .foregroundStyle(.gray100)
                    Spacer()
                }
                
                Spacer().frame(height: 24)
                
                VStack(alignment:.leading) {
                    Text("반려견 이름")
                        .font(.body_14_sb)
                    PKTextField(text: .constant(""))
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading) {
                    Text("성별")
                        .font(.body_14_sb)
                    HStack {
                        ChoiceButton("남아")
                        ChoiceButton("여아")
                    }
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading) {
                    Text("견종")
                        .font(.body_14_sb)
                    PKTextField(text: .constant(""))
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading) {
                    Text("나이")
                        .font(.body_14_sb)
                    HStack {
                        ChoiceButton("나이를 알아요")
                        ChoiceButton("나이를 몰라요")
                    }
                }
                
                Spacer()
                
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    DogInfoView()
}
