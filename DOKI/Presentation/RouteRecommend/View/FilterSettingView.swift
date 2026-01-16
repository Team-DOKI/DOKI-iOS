//
//  FilterSettingView.swift
//  DOKI
//
//  Created by a on 11/3/25.
//

import SwiftUI

struct FilterSettingView: View {
    @ObservedObject var viewModel: FilterSettingViewModel
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 40) {
                    walkTimeSection
                    
                    congestionSection
                    
                    dogInteractionSection
                    
                    safetySection
                    
                    convenienceSection
                    
                    environmentSection
                    
                    Spacer().frame(height: 20)
                }
                .padding(.horizontal, 16)
                .padding(.top, 26)
            }
            
            MainButton(text: "적용하기") {
                viewModel.saveOption()
            }
            .padding(.horizontal, 16)
        }
        .topNavigationView(left: {
            BackButton {
                viewModel.navigateToBack()
            }
        }, center: {
            Text("필터링 선택")
                .subtitle()
        })
    }
}

extension FilterSettingView {
    // 소요 시간
    private var walkTimeSection: some View {
        SelectableSection(
            title: "산책 소요 시간",
            subtitle: "(분)",
            selectionMode: .single,
            items: $viewModel.walkTimeOption
        )
    }
    
    // 혼잡도
    private var congestionSection: some View {
        VStack(spacing: 16) {
            SectionHeader(
                title: "혼잡도"
            )
            
            SegmentedButton(
                items: viewModel.congestionOption,
                selectedItem: $viewModel.selectedCongestion
            )
        }
    }
    
    // 강아지 교류 빈도
    private var dogInteractionSection: some View {
        VStack(spacing: 16) {
            SectionHeader(
                title: "강아지 교류 빈도"
            )
            
            SegmentedButton(
                items: viewModel.dogInteractionOption,
                selectedItem: $viewModel.selectedDogInteraction
            )
        }
    }
    
    // 안전
    private var safetySection: some View {
        SelectableSection(
            title: "안전",
            subtitle: "(복수 선택 가능)",
            items: $viewModel.safetyOption
        )
    }
    
    // 편의성
    private var convenienceSection: some View {
        SelectableSection(
            title: "편의성",
            subtitle: "(복수 선택 가능)",
            items: $viewModel.convenienceOption
        )
    }
    
    // 환경
    private var environmentSection: some View {
        SelectableSection(
            title: "환경",
            subtitle: "(복수 선택 가능)",
            items: $viewModel.environmentOption
        )
    }
}
