//
//  HomeView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Image(.imgLogo)
                    .padding(.top, 7)
                    .padding(.bottom, 9)
                
                HStack(spacing: 8) {
                    HStack(spacing: 2) {
                        Image(.icSun)
                        
                        Text("35°C")
                            .foregroundStyle(.contents)
                            .font(.subActive)
                    }
                    
                    HStack(spacing: 2) {
                        Image(.icDrop)
                        
                        Text("0mm")
                            .foregroundStyle(.contents)
                            .font(.subActive)
                    }
                    
                    Spacer()
                    
                    AddressTag(text: "강남구 역삼동")
                }
                .padding(.bottom, 26)
                
                WalkStatsView(distance: 0.0, totalTime: "00:00:00", count: 0)
                    .padding(.bottom, 24)
                
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("단지와 함께")
                            .font(.subtitle)
                            .foregroundStyle(.contents)
                        
                        Text("지금 산책을 시작해보세요!")
                            .font(.bodyDefault)
                            .foregroundStyle(.contents)
                    }
                    
                    Spacer()
                    
                    Button {
                    } label: {
                        Text("산책 시작")
                            .font(.bodyBold)
                            .foregroundStyle(.defaultBackground)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(.defaultPrimary)
                            .cornerRadius(999)
                    }
                }
            }
            .padding(.horizontal, 16)
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("내 반려견은 어떤 성향을 가지고 있을까?")
                        .font(.bodyBold)
                        .foregroundStyle(.defaultBackground)
                    
                    Text("간단한 테스트를 통해 반려견 성향을 알아보세요!")
                        .font(.subDefault)
                        .foregroundStyle(.defaultBackground)
                }
                
                Spacer()
            }
            .padding(20)
            .background(.defaultPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("인기있는 산책 루트 추천")
                    .font(.header3)
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(1...10, id: \.self) { _ in
                            WalkCourseCell()
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 60)
            
            Spacer()
        }
    }
}

struct WalkStatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.bodyBold)
                .foregroundColor(.defaultPrimary)
            Text(value)
                .font(.bodyActive)
                .foregroundColor(.defaultPrimary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct WalkStatsView: View {
    var distance: Double = 0.0
    var totalTime: String = "00:00:00"
    var count: Int = 0
    
    var body: some View {
        HStack(spacing: 0) {
            WalkStatItem(title: "누적 거리", value: String(format: "%.1f KM", distance))
            
            Divider()
                .frame(height: 40)
                .background(.defaultPrimary)
            
            WalkStatItem(title: "총 산책 시간", value: totalTime)
            
            Divider()
                .frame(height: 40)
                .background(.defaultPrimary)
            
            WalkStatItem(title: "산책 횟수", value: "\(count) 회")
        }
        .padding(16)
        .background(.opacity5)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(.defaultPrimary, lineWidth: 1)
        )
    }
}
