//
//  HomeView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

struct HomeView: View {
    let topSafeAreaInset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    let dummyData = ["이륜차 거의 없음", "배변 쓰레기통", "쉼터", "편의점", "동반 카페", "아스팔트/벽돌", "시끌벅적"]
    
    @EnvironmentObject var router: Coordinator<HomeScene>
    @EnvironmentObject var tabBarstate: TabBarState
    @StateObject var viewModel = HomeViewModel()
    @StateObject var courseDetailViewModel = CourseDetailViewModel()
    @State var isShowContextMenu = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                Color.pawkeyWhite2
                
                VStack(spacing: 0) {
                    topHeaderView
                        .opacity(0)
                    VStack(alignment: .leading) {
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
                        Text("최근 산책")
                            .font(.head_18_sb)
                            .foregroundStyle(.pawkeyBlack)
                        
                        ReviewCard(type: .others, walkRouteImg: "walkRoute", profileImg: "profile", walkTitle: "외로운 산책", petName: "길냥이", postDate: "2025/01/02", buttonPressed: true, data: dummyData)
                            .onTapGesture {
                                courseDetailViewModel.images = [.walkRoute, .profile, .profile2, .profile3]
                                tabBarstate.isHidden = true
                                router.push(.sharedCourseDetail(courseDetailViewModel))
                            }
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                }
                .padding(.top, -topSafeAreaInset)
                .onTapGesture {
                    viewModel.isShowMenu = false
                }
            }
            Spacer().frame(height: 60)
        }
        .background(.pawkeyWhite2)
        .overlay(alignment: .top, content: {
            topHeaderView
        })
        .contextMenu(isPresented: $viewModel.isShowMenu) {
            contextMenu
        }
    }
    
    private var contextMenu: some View {
        ZStack {
            VStack(alignment: .trailing, spacing: 0) {
                topHeaderView

                if isShowContextMenu {
                    HStack(spacing: 6) {
                        Image(.systemIcon)
                        Text("내 지역 관리")
                            .font(.body_16_sb)
                            .foregroundStyle(.pawkeyBlack)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.trailing, 16)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.isShowMenu = false
                        }
                        router.push(.changeMyArea)
                    }
                }

                Spacer()
            }
            .padding(.top, -topSafeAreaInset)
        }
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isShowContextMenu = true
            }
        }
        .onDisappear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isShowContextMenu = false
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isShowContextMenu)
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
        .background(.pawkeyWhite1)
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
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(contentMode: .fill)
        }
        .background(.pawkeyWhite1)
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
            .frame(maxWidth: .infinity, minHeight: 120)
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
        .background(.pawkeyWhite1)
        .cornerRadius(12)
    }
}


