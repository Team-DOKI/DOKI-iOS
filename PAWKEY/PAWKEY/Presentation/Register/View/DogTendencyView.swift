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
                    .font(.head_24_sb)
                    .foregroundStyle(.pawkeyBlack)
                
                Spacer().frame(height: 42)
                
                ForEach(viewModel.petTraitsCategories, id: \.self.categoryId) { category in
                    Text(category.categoryName)
                        .font(.body_14_sb)
                    Spacer().frame(height: 8)
                    LazyVGrid(columns: columns) {
                        ForEach(category.categoryOptions, id: \.self.categoryOptionId) { option in
                            LocationButton(
                                option.categoryOptionText,
                                isSelected: viewModel.userProfile.petTraits.isSelected(categoryId: category.categoryId, optionId: option.categoryOptionId)
                            )
                            .disabled(true)
                            .onTapGesture {
                                viewModel.changeUserInfo(.petTraits(categoryId: category.categoryId, optionId: option.categoryOptionId))
                            }
                        }
                    }
                    Spacer().frame(height: 30)
                }
            }
            .padding(.horizontal, 16)
        }
        .task {
            await viewModel.fetchPetTraitsCategories()
        }
    }
}


