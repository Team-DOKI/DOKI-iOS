//
//  RouteRecommendView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct RouteRecommendView: View {
    @ObservedObject var viewModel: RecommendViewModel
    
    @State private var isSortMenuPresented = false
    @State private var selectedSort: SortOption = .latest
    
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
            
            ZStack(alignment: .topTrailing) {
                courseGridSection
                
                if isSortMenuPresented {
                    sortMenu
                        .padding(.trailing, 16)
                        .zIndex(1)
                }
            }
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
            let hasSelectedItemEmpty = viewModel.selectedFilterOption.isEmpty
            
            FilterButton(isActive: !hasSelectedItemEmpty) {
                viewModel.navigateToFilterSetting()
            }
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                if hasSelectedItemEmpty {
                    HStack(spacing: 8) {
                        ForEach(viewModel.filterTags, id: \.text) { tag in
                            FilteringTag(text: tag.text, isActive: tag.isActive)
                        }
                    }
                    .padding(.trailing, 16)
                } else {
                    HStack(spacing: 8) {
                        ForEach(viewModel.selectedFilterOption, id: \.text) { tag in
                            FilteringTag(text: tag.text, isActive: tag.isActive)
                        }
                    }
                    .padding(.trailing, 16)
                }
            }
        }
    }

    private var sortSection: some View {
        HStack {
            Text("000개의 루트")
                .font(.bodySmall)
                .foregroundStyle(.defaultDark)
            
            Spacer()
            
            Button {
                withAnimation(.easeInOut) {
                    isSortMenuPresented.toggle()
                }
            } label: {
                HStack(spacing: 0) {
                    Text(selectedSort.rawValue)
                        .subDefault(color: .defaultDark)
                    
                    Image(.btnDown)
                        .renderingMode(.template)
                        .foregroundStyle(.defaultDark)
                        .rotationEffect(.degrees(isSortMenuPresented ? 180 : 0))
                }
            }
        }
    }
    
    private var sortMenu: some View {
        VStack(spacing: 2) {
            ForEach(SortOption.allCases, id: \.self) { option in
                Button {
                    selectedSort = option
                    isSortMenuPresented = false
                } label: {
                    Text(option.rawValue)
                        .font(.small)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 2)
                        .padding(.leading, 8)
                        .foregroundStyle(option == selectedSort ? .defaultPrimary : .defaultMiddle)
                        .background(option == selectedSort ? Color.primaryGra1 : Color.clear)
                }
            }
        }
        .padding(.vertical, 4)
        .background(.white)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .inset(by: 0.5)
                .stroke(.defaultBright, lineWidth: 1)
        )
        .frame(width: 67)
        .offset(y: -10)
    }
    
    private var courseGridSection: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(1...10, id: \.self) { _ in
//                    RouteCell()
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 80)
        }
        .zIndex(0)
    }
}

enum SortOption: String, CaseIterable {
    case latest = "최신순"
    case popular = "인기순"
}
