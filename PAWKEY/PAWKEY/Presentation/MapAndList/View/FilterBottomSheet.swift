//
//  FilterBottomSheet.swift
//  PAWKEY
//
//  Created by 권석기 on 7/11/25.
//

import SwiftUI

struct FilterBottomSheet: View {
    @ObservedObject var viewModel: MapAndListViewModel
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 28)
                    Text("산책 경로 옵션")
                        .font(.head_20_b)
                        .padding(.leading, 16)
                    
                    Spacer().frame(height: 36)
                    
                    Text("단일 선택 옵션")
                        .font(.caption_12_sb)
                        .foregroundStyle(.green500)
                        .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
                        .padding(.leading, 16)
                        .animation(nil)
                    
                    ForEach(viewModel.filterItemList.selecteList, id: \.self) { selectedList in
                        RadioGroup(
                            isExpanded: Binding(
                                get: { viewModel.singleItemexpandedGroup[selectedList.selectId] ?? false },
                                set: { viewModel.singleItemexpandedGroup[selectedList.selectId] = $0 }
                            ),
                            title: selectedList.selectName,
                            items: selectedList.options
                        ) { selected in
                            viewModel.selectSingleItem(selected)
                        }
                    }
                    
                    Spacer().frame(height: 36)
                    Text("복수 선택 옵션")
                        .font(.caption_12_sb)
                        .foregroundStyle(.green500)
                        .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
                        .padding(.leading, 16)
                        .animation(nil)
                    
                    ForEach(viewModel.filterItemList.categoryList   , id: \.self) { selectedList in
                        CheckBoxGroup(
                            isExpanded: Binding(
                                get: { viewModel.mutipleItemexpandedGroup[selectedList.selectId] ?? false },
                                set: { viewModel.mutipleItemexpandedGroup[selectedList.selectId] = $0 }
                            ),
                            title: selectedList.selectName,
                            items: selectedList.options
                        ) { selected in
                            viewModel.selectMultipleItem(selected)
                        }
                    }
                }
            }
        }
        HStack {
            CTAButton(title: "옵션 적용하기") {
                viewModel.saveFilterOption()
            }
            Button {
                viewModel.resetAllOptions()
            } label: {
                VStack {
                    Image(.rotateIcon)
                }
                .frame(maxWidth: 56, minHeight: 56)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray50)
            )
        }
        .padding(.horizontal, 16)
    }
}
