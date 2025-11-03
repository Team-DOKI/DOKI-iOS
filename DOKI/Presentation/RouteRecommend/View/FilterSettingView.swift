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
            ScrollView {
                VStack(spacing: 40) {
                    walkTimeSection
                    congestionSection
                    dogInteractionSection
                    safetySection
                    convenienceSection
                    environmentSection
                    Spacer().frame(height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
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
        VStack(spacing: 16) {
            HStack {
                Text("산책 소요 시간").subtitle()
                Text("(분)").subDefault(color: .default)
                Spacer()
            }
            RangeSlider(
                start: 10,
                end: 60,
                value: $viewModel.walkTime
            )
        }
    }
    
    // 혼잡도
    private var congestionSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("혼잡도").subtitle()
                Text("(단일 선택 가능)").subDefault(color: .default)
                Spacer()
            }
            SegmentedButton(
                items: viewModel.congestionOption,
                selectedItem: $viewModel.selectedCongestion
            )
        }
    }
    
    // 강아지 교류 빈도
    private var dogInteractionSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("강아지 교류 빈도").subtitle()
                Text("(단일 선택 가능)").subDefault(color: .default)
                Spacer()
            }
            SegmentedButton(
                items: viewModel.dogInteractionOption,
                selectedItem: $viewModel.selectedDogInteraction
            )
        }
    }
    
    // 안전
    private var safetySection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("안전").subtitle()
                Text("(복수 선택 가능)").subDefault(color: .default)
                Spacer()
            }
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach($viewModel.safetyOption, id: \.self) { $filterOption in
                        SelectButton(text: filterOption.text, isActive: filterOption.isActive) {
                            filterOption.isActive.toggle()
                        }
                    }
                }
            }
        }
    }
    
    // 편의성
    private var convenienceSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("편의성").subtitle()
                Text("(복수 선택 가능)").subDefault(color: .default)
                Spacer()
            }
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach($viewModel.convenienceOption, id: \.self) { $filterOption in
                        SelectButton(text: filterOption.text, isActive: filterOption.isActive) {
                            filterOption.isActive.toggle()
                        }
                    }
                }
            }
        }
    }
    
    // 환경
    private var environmentSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("환경").subtitle()
                Text("(복수 선택 가능)").subDefault(color: .default)
                Spacer()
            }
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach($viewModel.environmentOption, id: \.self) { $filterOption in
                        SelectButton(text: filterOption.text, isActive: filterOption.isActive) {
                            filterOption.isActive.toggle()
                        }
                    }
                }
            }
        }
    }
}
