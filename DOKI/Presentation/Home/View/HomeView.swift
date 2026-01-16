//
//  HomeView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

import Moya

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
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
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 26)
            
            ScrollView {
                VStack(spacing: 0) {
                    TotalStatBox(distance: 0.0, totalTime: "00:00:00", count: 0)
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
                        .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(1...10, id: \.self) { _ in
                                WalkCourseCell()
                            }
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.leading, 16)
                }
                .padding(.bottom, 24)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("비슷한 이용자 루트 추천")
                        .font(.header3)
                        .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(1...10, id: \.self) { _ in
                                WalkCourseCell()
                            }
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.leading, 16)
                }
                .padding(.bottom, 100)
            }
        }
        .scrollIndicators(.hidden)
    }
}
