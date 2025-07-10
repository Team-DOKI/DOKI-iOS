//
//  DogTendencyView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI

struct DogTendencyView: View {    
    @ObservedObject var viewModel: ProfileSetUpViewModel
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
      
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                Spacer().frame(height: 20)
                
                Text("반려견 성향은 어떤가요?")
                    .font(.head_22_sb)
                    .foregroundStyle(.pawkeyBlack)
                
                Spacer().frame(height: 42)
                
                VStack(alignment:.leading) {
                    Text("에너지 레벨")
                        .font(.body_14_sb)
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.energyLevel, id: \.self) {
                            ChoiceButton($0, isSelected: $0 == viewModel.userProfile.energyLevel) { result in
                                viewModel.changeUserInfo(.energyLevel(result))
                            }
                        }
                    }
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading) {
                    Text("사회성 레벨")
                        .font(.body_14_sb)
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.societyLevel, id: \.self) {
                            ChoiceButton($0, isSelected: $0 == viewModel.userProfile.societyLevel) { result in
                                viewModel.changeUserInfo(.societyLevel(result))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
