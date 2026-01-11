//
//  WalkResultView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct WalkResultView: View {
    @StateObject var viewModel: WalkResultViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                congestionSection
                Spacer().frame(height: 40)
                dogInteractionSection
                Spacer().frame(height: 40)
                safetySection
                Spacer().frame(height: 40)
                convenienceSection
                Spacer().frame(height: 40)
                environmentSection
                Spacer().frame(height: 40)
                reviewSection
            }
            .padding(.horizontal, 16)
        }
        .topNavigationView {
            BackButton(action: {})
        } center: {
            Text("산책 기록하기")
                .subtitle()
        }

    }
}

extension WalkResultView {
    private var congestionSection: some View {
        VStack(spacing: 16) {
            SectionHeader(
                title: "혼잡도",
                subtitle: "(단일 선택 가능)"
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
                title: "강아지 교류 빈도",
                subtitle: "(단일 선택 가능)"
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
    private var reviewSection: some View {
        VStack {}
    }
}
