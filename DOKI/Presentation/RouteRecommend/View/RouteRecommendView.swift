//
//  RouteRecommendView.swift
//  PAWKEY
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
                .padding(.trailing, 16)
                .padding(.vertical, 8)
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
            FilterButton(isActive: true) {
                viewModel.navigateToFilterSetting()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.filterTags, id: \.self) { tag in
                        FilteringTag(text: tag.text, isActive: tag.isActive)
                    }
                }
            }
        }
    }
    
    private var sortSection: some View {
        HStack {
            Text("최신순")
                .subDefault(color: .default)
            Image(.chevronDown)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var courseGridSection: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(1...10, id: \.self) { _ in
                    WalkCourseCell()
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct FilterTag: Hashable {
    let text: String
    let isActive: Bool
}
