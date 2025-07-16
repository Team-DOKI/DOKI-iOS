//
//  MapAndListView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapAndListView: View {
    @EnvironmentObject var coordinator: Coordinator<WalkScene>
    
    @StateObject private var walkCourseViewModel = WalkCourseViewModel()
    @StateObject private var mapAndListViewModel = MapAndListViewModel()
    
    @Namespace private var namespace
    
    @State private var tab: MapAndListTab = .map
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                ForEach(MapAndListTab.allCases, id: \.self) { tab in
                    TabButton(
                        title: tab.rawValue,
                        isSelected: walkCourseViewModel.selectedMode == tab,
                        namespace: namespace
                    ) {
                        walkCourseViewModel.selectedMode = tab
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            .padding(.leading, 16)
            
            switch walkCourseViewModel.selectedMode {
            case .map:
                mapView
            case .list:
                courseListView
            }
        }
        .onAppear {
            walkCourseViewModel.requestPermission()
        }
        .task {
            await mapAndListViewModel.fetchFilterOptions()
        }
        .fullScreenCover(isPresented: $walkCourseViewModel.showWalkCourseView) {
            WalkCourseView(viewModel: walkCourseViewModel, showWalkCourseView: $walkCourseViewModel.showWalkCourseView) { distance, elapsedTime, stepCount, snapshot in
                coordinator.push(.walkCompletion(
                    distance: distance,
                    elapsedTime: elapsedTime,
                    stepCount: stepCount,
                    snapshot: snapshot
                ))
                walkCourseViewModel.resetTrackingData()
            }
        }
        .sheet(isPresented: $mapAndListViewModel.isShowSheet) {
            FilterBottomSheet(viewModel: mapAndListViewModel)
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.9)])
        }
    }
}

extension MapAndListView {
    private var mapView: some View {
        Group {
            ZStack(alignment: .topLeading) {
                WalkMap(region: $walkCourseViewModel.region,
                        pathCoordinates: $walkCourseViewModel.pathCoordinates,
                        shouldCenterOnUser: $walkCourseViewModel.shouldCenterOnUser,
                        userTrackingMode: $walkCourseViewModel.userTrackingMode)
                .edgesIgnoringSafeArea(.bottom)
                .overlay(
                    VStack {
                        Spacer()
                        
                        ZStack {
                            Button {
                                walkCourseViewModel.showWalkCourseView = true
                            } label: {
                                Text("산책 기록 시작하기")
                                    .font(.body_16_sb)
                                    .foregroundColor(.pawkeyWhite1)
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .background(.green500)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    walkCourseViewModel.centerMapOnCurrentLocation()
                                    walkCourseViewModel.shouldCenterOnUser = true
                                }) {
                                    Image(.mapGps)
                                }
                                .padding(.trailing, 16)
                            }
                        }
                        .padding(.bottom, 98)
                    },
                    alignment: .bottom
                )
                
                Text("서대문구 홍은동")
                    .font(.body_16_sb)
                    .foregroundColor(.green500)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(.pawkeyWhite1)
                    .cornerRadius(60)
                    .padding(.top, 18)
                    .padding(.leading, 16)
            }
        }
    }
    
    private var courseListView: some View {
        VStack {
            HStack {
                Button {
                    mapAndListViewModel.isShowSheet = true
                } label: {
                    Circle()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(.pawkeyWhite1)
                        .overlay {
                            Circle()
                                .stroke(Color.gray100, lineWidth: 1)
                        }
                        .overlay(Image(.settingGray))
                }
                Spacer()
                if mapAndListViewModel.selectedFilterItem.isEmpty {
                    HStack {
                        FilterChip(title: "")
                        Spacer()
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(mapAndListViewModel.selectedFilterItem, id: \.self) {
                                FilterChip(title: $0.selectText)
                            }
                        }
                        .padding(.vertical, 1)
                    }
                }
            }
            .padding(.horizontal, 16)
            if mapAndListViewModel.posts.isEmpty {
                Color.pawkeyWhite2
            } else {
                ScrollView(showsIndicators: false) {
                    Spacer().frame(height: 34)
                    VStack {
                        ForEach(mapAndListViewModel.posts, id: \.self) { post in
                            ReviewCard(
                                type: .others,
                                walkRouteImg: post.representativeImageUrl,
                                profileImg: post.writer.petProfileImageUrl,
                                walkTitle: post.title,
                                petName: post.writer.petName,
                                postDate: post.createdAt,
                                buttonPressed: post.isLike,
                                data: post.descriptionTags
                            )
                            .onTapGesture {
                                coordinator.push(.courseDetail(postId: post.postId))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .background(.pawkeyWhite2)
            }
        }
        .padding(.top, 10)
        .task {
            if !mapAndListViewModel.isSearchRequested {
                await mapAndListViewModel.fetchPosts()
            }
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Text(title)
                    .font(.head_22_b)
                    .foregroundColor(isSelected ? .pawkeyBlack : .gray200)
                
                if isSelected {
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.pawkeyBlack)
                        .matchedGeometryEffect(id: "arrow", in: namespace)
                } else {
                    Color.clear
                        .frame(height: 4)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
