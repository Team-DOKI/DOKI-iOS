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
                    .overlay {
                        if viewModel.loadingStatus == .loading {
                            ProgressView()
                        }
                    }
                
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
        .onAppear {
            viewModel.loadPosts()
        }
    }
    
    private var bannerSection: some View {
        Banner(imageName: ["img_banner_1", "img_banner_2", "img_banner_3", "img_banner_4", "img_banner_5", "img_banner_6"])
    }
    
    private var filterSection: some View {
        HStack(spacing: 8) {
            let hasFilter = !viewModel.filterOptions.isEmpty

            FilterButton(isActive: hasFilter) {
                viewModel.navigateToFilterSetting()
            }


            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    if !hasFilter {
                        ForEach(FilterCategory.allCases, id: \.self) { category in
                            FilteringTag(text: category.title, isActive: false)
                        }
                    } else {
                        // 카테고리 원래 순서 그대로 표시
                        ForEach(viewModel.filterOptions, id: \.id) { filterList in
                            let activeOptions = filterList.options.filter { $0.isActive }
                            if !activeOptions.isEmpty {
                                ForEach(activeOptions, id: \.id) { option in
                                    FilteringTag(text: displayText(for: option, in: filterList), isActive: true)
                                }
                            } else {
                                FilteringTag(text: filterList.name, isActive: false)
                                    .onTapGesture {
                                        viewModel.navigateToFilterSetting(focusedType: filterList.filterType)
                                    }
                            }
                        }
                    }
                }
                .padding(.trailing, 16)
            }
        }
    }

    private func displayText(for option: FilteringOption, in filterList: FilterList) -> String {
        switch filterList.filterType {
        case .congestion:
            return "혼잡도 \(option.text)"
        case .exchange:
            return option.text.hasPrefix("교류") ? option.text : "교류 \(option.text)"
        default:
            return option.text
        }
    }
    
    private var sortSection: some View {
        HStack {
            Text("\(viewModel.posts.count)개의 루트")
                .font(.bodySmall)
                .foregroundStyle(.defaultDark)
            
            Spacer()
            
            Button {
                withAnimation(.easeInOut) {
                    isSortMenuPresented.toggle()
                }
            } label: {
                HStack(spacing: 0) {
                    Text(viewModel.selectedSort.displayText)
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
                    viewModel.selecteSortOption(option)
                    isSortMenuPresented = false
                } label: {
                    Text(option.displayText)
                        .font(.small)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 2)
                        .padding(.leading, 8)
                        .foregroundStyle(option == viewModel.selectedSort ? .defaultPrimary : .defaultMiddle)
                        .background(option == viewModel.selectedSort ? Color.primaryGra1 : Color.clear)
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
                ForEach(viewModel.posts, id: \.self.postId) { post in
                    RouteCell(post: post) {
                        viewModel.toggleLike(postId: post.postId)
                    }
                    .onTapGesture { viewModel.navigateToRouteDetail(postId: post.postId) }
                    .onAppear {
                        if "\(post.postId)" == viewModel.nextCursorId {
                            viewModel.fetchPosts()
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 80)
        }
        .zIndex(0)
    }
}


