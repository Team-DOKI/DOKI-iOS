//
//  CourseDetailView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct CourseDetailView: View {
    @ObservedObject var viewModel: CourseDetailViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // TODO: 임시 지도영역
            ZStack(alignment: .bottom) {
                mapView
                titleSection
            }
            VStack(alignment: .leading, spacing: 0) {
                Divider()
                profileSection
                Divider()
                walkInfoSection
                divider
                reviewSection
                divider
                reviewRatingSection
                divider
                buttonSection
                Spacer().frame(height: 40)
            }
        }
        .overlay(alignment: .top, content: {
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(.defaultButton)
        })
        .topNavigationView {
            BackButton(action: viewModel.navigateToBack)
        } center: {
            Text("루트 상세 정보")
                .subtitle()
        }
        .ignoresSafeArea(.container, edges: [.bottom])
    }
}

extension CourseDetailView {
    private var mapView: some View {
        Image(.mapView)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: 292)
    }
    private var titleSection: some View {
        Text("단지와의 룰루랄라")
            .header3()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .cornerRadius(16, corners: [.topLeft, .topRight])
    }
    
    private var profileSection: some View {
        HStack(spacing: 10) {
            Image("")
                .resizable()
                .frame(width: 43, height: 43)
                .background(.gray)
                .clipShape(Circle())
            
            Text("단지")
                .subtitle(color: .defaultDark)
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
    
    private var walkInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Label(title: {Text(viewModel.address)}, icon: {Image(.icMarker)})
                    .font(.bodyActive)
                    .foregroundStyle(.defaultDark)
                Label(title: {Text(viewModel.recordDate)}, icon: {Image(.icTimeclock)})
                    .font(.bodyActive)
                    .foregroundStyle(.defaultDark)
                Label(title: {Text(viewModel.walkRecord)}, icon: {Image(.icInfo)})
                    .font(.bodyActive)
                    .foregroundStyle(.defaultDark)
            }
            
            VStack {
                if viewModel.isExpanded {
                    FlexibleGrid(availableWidth: 350, data: viewModel.tagList, spacing: 8, alignment: .leading) { tagName in
                        Tag(text: tagName)
                    }
                } else {
                    HStack {
                        ForEach(viewModel.tagList.prefix(4), id: \.self) { tagName in
                            Tag(text: tagName)
                        }
                        Spacer()
                    }
                }
            }
            .padding(.vertical, 10)
            
            if viewModel.tagList.count > 4 && !viewModel.isExpanded {
                HStack {
                    Rectangle()
                        .frame(height: 1.5)
                        .foregroundStyle(.defaultButton)
                    Text("+ \(viewModel.tagList.count - 4)")
                        .bodySmall(color: .defaultMiddle)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        .clipShape(Capsule())
                        .background(.defaultButton)
                        .clipShape(Capsule())
                    Rectangle()
                        .frame(height: 1.5)
                        .foregroundStyle(.defaultButton)
                }
                .onTapGesture {
                    viewModel.isExpanded = true
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
    
    private var divider: some View {
        Rectangle()
            .frame(height: 8)
            .foregroundStyle(.defaultButton)
    }
    
    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(1...3, id: \.self) { _ in
                        Image("")
                            .resizable()
                            .frame(width: 110, height: 110)
                            .background(.gray)
                    }
                }
            }
            
            Text("후기 글 본문 후기 글 본문 후기 글 본문ㅇ 후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
    
    private var reviewRatingSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Text("이런 점이 좋았어요")
                    .mainActive()
                Label(title: {
                    Text("후기숫자")
                }, icon: {
                    Image(.icEdit)
                })
                .font(.subDefault)
                .foregroundStyle(.defaultMiddle)
                Spacer()
            }
            .padding(.vertical, 16)
            
            VStack(spacing: 10) {
                ForEach(1...3, id: \.self) { rank in
                    ReviewChart(text: "후기 옵션", rank: rank)
                }
            }
            .padding(.vertical, 12)
        }
        .padding(.horizontal, 16)
    }
    
    private var buttonSection: some View {
        HStack(spacing: 8) {
            Button {
                
            } label: {
                Text("삭제하기")
                    .subtitle(color: .defaultRed)
                    .frame(maxWidth: .infinity, maxHeight: 56)
            }
            .overlay(
                RoundedCorner(radius: 8)
                    .stroke(.defaultRed, lineWidth: 1)
            )
            
            MainButton(text: "수정하기")
        }
        .padding(.top, 40)
        .padding(.horizontal, 16)
    }
    
}

//#Preview {
//    CourseDetailView()
//}
