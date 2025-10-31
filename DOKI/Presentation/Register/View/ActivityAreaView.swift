//
//  ActivityAreaView.swift
//  PAWKEY
//
//  Created by a on 10/31/25.
//

import SwiftUI

struct ActivityAreaView: View {
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
        .sheet(isPresented: $viewModel.isShowActivityArea) {
            AreaSearchView(viewModel: viewModel)
                .presentationDetents([.height(600)])
        }
        .onChange(of: viewModel.selectedDongId) { _ in
            viewModel.toggleActivityArea()
            viewModel.isShowMapView = true
        }
    }
    
    private var infoViewTitle: some View {
        VStack(spacing: 4) {
            Text("산책하기 전\n간단한 정보를 입력해주세요").header2()
            Text("서비스 시작을 위해 간단한 정보를 입력해주세요!").bodyDefault()
        }
    }
    
    private var searchTextField: some View {
        SearchField(
            placeholder: "주로 산책하는 지역을 검색해보세요",
            text: $viewModel.regionDisplayName
        )
        .disabled(true)
        .overlay {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.toggleActivityArea()
                }
        }
    }
}
