//
//  RouteRecommendView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct RouteRecommendView: View {
    @ObservedObject var viewModel: RecommendViewModel
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        VStack(spacing: 0) {
            bannerSection
            
            filterSection
                .padding(.leading, 16)
                .padding(.top, 16)
            
            sortSection
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            
            courseGridSection
        }
        .topNavigationView(center: {
            Text("산책 루트 추천")
                .subtitle()
        })
    }
    
    private var bannerSection: some View {
        Banner(imageName: ["", "", "", ""])
    }
    
    private var filterSection: some View {
        HStack(spacing: 8) {
            FilterButton(isActive: !viewModel.selectedFilterOption.isEmpty) {
                viewModel.navigateToFilterSetting()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    let items = viewModel.selectedFilterOption.isEmpty ? viewModel.dummyFilterOption : viewModel.selectedFilterOption
                    ForEach(items, id: \.self) { tag in
                        FilteringTag(text: tag.text, isActive: tag.isActive)
                    }
                }
            }
        }
    }
    
    private var sortSection: some View {
        HStack(spacing: 0) {
            Text("000개의 루트")
                .font(.bodySmall)
                .foregroundStyle(.defaultDark)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("인기순")
                    .subDefault(color: .defaultDark)
                
                Image(.btnDown)
                    .renderingMode(.template)
                    .foregroundStyle(.defaultDark)
            }
        }
    }
    
    private var courseGridSection: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(1...10, id: \.self) { _ in
                    WalkCourseCell()
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 80)
        }
    }
}
