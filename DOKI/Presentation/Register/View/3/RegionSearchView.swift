//
//  AreaSearchView.swift
//  DOKI
//
//  Created by a on 10/31/25.
//

import SwiftUI

struct RegionSearchView: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("산책 지역")
                .subtitle()
                .padding(.vertical, 25)
            
            SearchField(placeholder: "지역을 검색해보세요", text: $viewModel.areaSearchText)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            
            HStack(spacing: 0) {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.regionList, id: \.self.gu.id) { district in
                            OptionItem(text: district.gu.name, isChecked: district.gu.id == viewModel.selectedGuId) {
                                viewModel.selectGuID(district.gu.id)
                            }
                        }
                    }
                    .frame(maxWidth: 80)
                }
                
                Divider().frame(maxWidth: 1, maxHeight: .infinity)
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.regionList.first {$0.gu.id == viewModel.selectedGuId}?.dongs ?? [], id: \.self.id) { dong in
                            OptionItem(text: dong.name, isChecked: dong.id == viewModel.selectedDongId) {
                                viewModel.seletDongId(dong.id)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            viewModel.fetchRegions()
        }
    }
}
