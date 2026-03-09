//
//  RegionView.swift
//  DOKI
//
//  Created by a on 10/31/25.
//

import SwiftUI

struct RegionView: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 20)
            
            infoViewTitle
            
            Spacer().frame(height: 40)
            
            Text("산책 지역").bodyActive()
            
            Spacer().frame(height: 8)
            
            searchTextField
        }
        .padding(.horizontal, 16)
        .onAppear {
            viewModel.fetchRegions()
        }
        .sheet(
            isPresented: Binding(
                get: { viewModel.regionFlow == .search },
                set: { _ in }
            )
        ) {
            RegionSearchView(
                regions: viewModel.regionList,
                selectedGuId: viewModel.selectedGuId,
                selectedDongId: viewModel.selectedDongId,
                searchText: $viewModel.areaSearchText,
                onSelectGu: { guId in
                    viewModel.selectGuID(guId)
                },
                onSelectDong: { dongId in
                    viewModel.seletDongId(dongId)
                },
                onDismiss: {
                    viewModel.regionFlow = .map
                }
            )
            .presentationDetents([.height(600)])
        }
    }
    
    private var infoViewTitle: some View {
        VStack(spacing: 4) {
            Text("산책하기 전\n간단한 정보를 입력해주세요").header2()
            
            Text("서비스 시작을 위해 간단한 정보를 입력해주세요!")
                .bodyDefault(color: .defaultMiddle)
        }
    }
    
    private var searchTextField: some View {
        SearchField(
            placeholder: "주로 산책하는 지역을 검색해보세요",
            text: $viewModel.selectedRegionName
        )
        .disabled(true)
        .overlay {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.regionFlow = .search
                }
        }
    }
}
