//
//  CourseListView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI
import CoreLocation

struct CourseListView: View {
    @EnvironmentObject var router: TabRouter<WalkScreen>
    
    @StateObject private var viewModel = WalkCourseViewModel()
    @StateObject private var courseListViewModel = CourseListViewModel()
    
    @State private var selectedMode: Int = 0
    @State private var showWalkCourseView = false
    @State private var shouldCenterOnUser: Bool = false
    
    let tabs: [(title: String, mode: Int)] = [("지도", 0), ("리스트", 1)]
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                ForEach(tabs, id: \.mode) { tab in
                    TabButton(
                        title: tab.title,
                        isSelected: selectedMode == tab.mode
                    ) {
                        selectedMode = tab.mode
                    }
                }
            }
            .frame(width: 155, height: 56)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            .padding(.leading, 16)
            
            if selectedMode == 0 {
                ZStack(alignment: .topLeading) {
                    WalkingMapView(region: $viewModel.region,
                                   pathCoordinates: $viewModel.pathCoordinates,
                                   shouldCenterOnUser: $shouldCenterOnUser,
                                   snapshotImage: .constant(nil))
                    .edgesIgnoringSafeArea(.bottom)
                    .overlay(
                        VStack {
                            Spacer()
                            
                            ZStack {
                                Button {
                                    showWalkCourseView = true
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
                                        viewModel.centerMapOnCurrentLocation()
                                        shouldCenterOnUser = true
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
            } else {
                VStack {
                    HStack {
                        Button {
                            courseListViewModel.isShowSheet = true
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
                    }
                    .padding(.horizontal, 16)
                    
                    ScrollView(showsIndicators: false) {
                        Spacer().frame(height: 34)
                        VStack {
                            ForEach(1...10, id: \.self) { _ in
                                WalkHistoryCard(
                                    type: .others,
                                    walkRouteImg: "walkRoute",
                                    profileImg: "profile",
                                    walkTitle: "제목을 입력해주세요",
                                    petName: "반려견 이름",
                                    postDate: "2025-07-11"
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
        .onAppear {
            viewModel.requestPermission()
        }
        .fullScreenCover(isPresented: $showWalkCourseView) {
            WalkCourseView(viewModel: viewModel, showWalkCourseView: $showWalkCourseView) { distance, elapsedTime, stepCount, snapshot in
                router.push(.walkCompletion(
                    distance: distance,
                    elapsedTime: elapsedTime,
                    stepCount: stepCount,
                    snapshot: snapshot
                ))
                viewModel.resetTrackingData()
            }
        }
        .sheet(isPresented: $courseListViewModel.isShowSheet) {
            WalkOptionSheet(viewModel: courseListViewModel)
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.9)])
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.head_22_b)
                    .foregroundColor(isSelected ? .pawkeyBlack : .gray200)
                
                Rectangle()
                    .frame(height: 4)
                    .foregroundColor(isSelected ? .pawkeyBlack : .clear)
            }
        }
        .buttonStyle(.plain)
    }
}
