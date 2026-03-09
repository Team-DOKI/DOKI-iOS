//
//  RegionSettingView.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct RegionSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: RegionSettingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 20)
            
            Text("산책 지역").bodyActive()
            
            Spacer().frame(height: 8)
            
            searchTextField
            
            Spacer()
            
            MainButton(
                text: "저장하기",
                buttonState: viewModel.isSaveButtonDisabled ? .disabled : .active1,
                action: viewModel.saveButtonTapped
            )
        }
        .padding(.horizontal, 16)
        .topNavigationView(left: {
            BackButton(action: { dismiss() })
        }, center: {
            Text("산책 지역 설정").subtitle()
        })
        .onChange(of: viewModel.isSaveCompleted) { _, completed in
            if completed {
                dismiss()
                viewModel.isSaveCompleted = false
            }
        }
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
                onSelectGu: { guId in
                    viewModel.selectGuID(guId)
                },
                onSelectDong: { dongId in
                    viewModel.selectDongId(dongId)
                },
                onDismiss: {
                    viewModel.regionFlow = .map
                }
            )
            .presentationDetents([.height(600)])
            
        }
        .overlay {
            if viewModel.regionFlow == .map {
                RegionMapView(
                    regionFlow: $viewModel.regionFlow,
                    previewRegionName: $viewModel.previewRegionName,
                    regionGeometry: viewModel.regionGeometry,
                    onSelectRegion: { viewModel.selectRegion() },
                    onResetSelection: { viewModel.resetRegionSelection() }
                )
            }
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
