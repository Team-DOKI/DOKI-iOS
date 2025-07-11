//
//  HomeView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

struct HomeView: View {
    let topSafeAreaInset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    @EnvironmentObject var router: Coordinator<HomeScreen>
    @EnvironmentObject var tabBarstate: TabBarState
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            Color.pawkeyWhite1
            
            VStack(spacing: 0) {
                topHeaderView
                VStack {
                    Spacer().frame(height: 12)
                    weatherView
                    Spacer().frame(height: 12)
                    HStack {
                        sunriseInfoView
                        Spacer().frame(width: 10)
                        startWalkButton
                    }
                    Spacer().frame(height: 12)
                    calendarView
                    Spacer().frame(height: 12)
                    recentWalkView
                }
                .padding(.horizontal, 16)
                Spacer()
            }
            .padding(.top, -topSafeAreaInset)
            .onTapGesture {
                viewModel.isShowMenu = false
            }
        }
        .contextMenu(isPresented: $viewModel.isShowMenu) {
            ZStack {
                VStack(alignment: .trailing, spacing: 0){
                    topHeaderView
                    HStack(spacing: 6) {
                        Image(.systemIcon)
                        Text("내 지역 관리")
                            .font(.body_16_sb)
                            .foregroundStyle(.pawkeyBlack)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                    .background(.white)
                    .cornerRadius(8)
                    .padding(.trailing, 16)
                    .onTapGesture {
                        viewModel.isShowMenu = false
                        router.push(.changeMyArea)
                    }
                    Spacer()
                }
                .padding(.top, -topSafeAreaInset)
            }
        }
    }
    
    private var topHeaderView: some View {
        VStack {
            HStack {
                Text("D+36")
                    .font(.caption_12_sb)
                    .foregroundStyle(.pawkeyWhite1)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 12)
                    .background(.pawkeyGreen)
                    .clipShape(Capsule())
                Text("연속산책")
                    .font(.body_14_sb)
                    .foregroundStyle(.pawkeyWhite1)
                Spacer()
                Button {
                    viewModel.isShowMenu = true
                } label: {
                    HStack {
                        Image(.location)
                        Text("강남구 역삼동")
                            .font(.body_14_sb)
                            .foregroundStyle(.pawkeyWhite1)
                        Image(.arrowDownWhite)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .padding(.top, topSafeAreaInset)
        }
        .background(.pawkeyBlack)
        .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
        .ignoresSafeArea(edges: .top)
    }
    
    private var weatherView: some View {
        HStack {
            Image(.sunnyIcon)
            Text("35°")
                .font(.head_22_sb)
                .foregroundStyle(.pawkeyBlack)
            Text("35°")
                .font(.body_14_r)
                .foregroundStyle(.pawkeyBlack)
            Text("21°")
                .font(.body_14_r)
                .foregroundStyle(.gray300)
            Spacer()
            Image(.rainyIcon)
            Text("0")
                .font(.head_22_sb)
            Text("ml")
                .font(.body_14_sb)
        }
        .padding(12)
        .background(.pawkeyWhite2)
        .cornerRadius(8)
    }
    
    private var sunriseInfoView: some View {
        VStack {
            Text("05:06")
                .font(.head_20_b)
                .padding(.top, 12)
            Spacer()
            Text("일출")
                .font(.body_16_sb)
                .foregroundStyle(.pawkeyBlack)
                .padding(.bottom, 12)
        }
        .frame(width: 91, height: 120)
        .background(alignment: .bottom) {
            Image(.sunrise)
        }
        .cornerRadius(15)
    }
    
    private var startWalkButton: some View {
        Button {
            tabBarstate.selectedTab = .walk
        } label: {
            HStack {
                Text("산책 시작하기")
                    .font(.head_24_b)
                    .foregroundStyle(.pawkeyWhite1)
                Spacer()
                Circle()
                    .foregroundStyle(.white)
                    .frame(height: 58)
                    .overlay(Image(.arrowRightBlack34))
            }
            .padding(.leading, 18)
            .padding(.trailing, 12)
            .frame(maxWidth: .infinity, maxHeight: 120)
            .background(alignment: .bottomTrailing) {
                Image(.dogFoot)
            }
            .background(.pawkeyBlack)
            .cornerRadius(15)
        }
    }
    
    private var calendarView: some View {
        HStack {
            HStack(alignment: .top) {
                Text("7월")
                    .font(.head_18_sb)
                    .foregroundStyle(.pawkeyBlack)
            }
            Spacer()
            ForEach(viewModel.dayList, id: \.self) { dayInfo in
                VStack(spacing: 15) {
                    Text(dayInfo.day)
                        .font(.body_14_r)
                        .foregroundStyle(.gray400)
                    Text("\(dayInfo.dayNumber)")
                        .font(.body_14_r)
                        .foregroundStyle(.gray400)
                    Circle()
                        .foregroundStyle(.green500)
                        .frame(width: 8, height: 8)
                }
                Spacer()
            }
        }
        .padding(16)
        .background(.pawkeyWhite2)
        .cornerRadius(12)
    }
    
    private var recentWalkView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("최근산책")
                .font(.body_14_sb)
                .foregroundStyle(.pawkeyWhite1)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.green400)
            
            Image(.map)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: 168)
                .background(.gray50)
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(.locationFill)
                            Text("강남구 역삼동")
                                .font(.body_14_m)
                                .foregroundStyle(.pawkeyWhite1)
                        }
                        HStack {
                            Image(.clockWhite)
                            Text("년도.월.일(요일) | 시작시간 - 종료 시간")
                                .font(.body_14_m)
                                .foregroundStyle(.pawkeyWhite1)
                        }
                    }
                    .padding(.leading, 16)
                    .padding(.bottom, 12)
                }
                .onTapGesture {
                    router.push(.sharedCourseDetail)
                    tabBarstate.isHidden = true
                }
            
            HStack(spacing: 6) {
                Chip(title: "산책 옵션 입력", isActive: true)
                Chip(title: "산책 옵션 입력", isActive: true)
            }
            .padding(16)
        }
        .background(.pawkeyWhite2)
        .cornerRadius(8)
    }
}


