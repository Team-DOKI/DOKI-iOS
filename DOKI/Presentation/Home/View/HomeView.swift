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
                        
                        Text(viewModel.temperatureText)
                            .foregroundStyle(.contents)
                            .font(.subActive)
                    }
                    
                    HStack(spacing: 2) {
                        Image(.icDrop)
                        
                        Text(viewModel.rainyText)
                            .foregroundStyle(.contents)
                            .font(.subActive)
                    }
                    
                    Spacer()
                    
                    AddressTag(text: viewModel.regionText)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 26)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    TotalWalkStatBox(distance: viewModel.totalDistance, totalTime: viewModel.totalWalkTimeText, count: viewModel.totalWalkCount)
                        .padding(.bottom, 24)
                    
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("\(viewModel.petName)\(viewModel.petName.josaWaGwa) 함께")
                                .font(.subtitle)
                                .foregroundStyle(.contents)
                            
                            Text("지금 산책을 시작해보세요!")
                                .font(.bodyDefault)
                                .foregroundStyle(.contents)
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.navigateToWalkRecord()
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
                    
                    VStack(spacing: 0) {
                        Spacer()
                        
                        Image(.imgUpperbodydog)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 87, height: 76)
                    }
                }
                .padding(.horizontal, 16)
                .background(.defaultPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("인기있는 산책 루트 추천")
                        .font(.header3)
                        .padding(.horizontal, 16)
                    
                    VStack(spacing: 16) {
                        Image(.imgSaddog)
                        
                        Text("곧 추천 루트가 채워질 예정이에요\n추후에 인기루트를 확인하실 수 있어요!")
                            .font(.subtitle)
                            .foregroundStyle(.defaultDark)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    
                    //                    ScrollView(.horizontal, showsIndicators: false) {
                    //                        HStack(spacing: 8) {
                    //                            ForEach(1...10, id: \.self) { _ in
                    //                                  RouteCell()
                    //                            }
                    //                        }
                    //                        .padding(.trailing, 16)
                    //                    }
                    //                    .padding(.leading, 16)
                }
                .padding(.bottom, 24)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("비슷한 이용자 루트 추천")
                        .font(.header3)
                        .padding(.horizontal, 16)
                    
                    VStack(spacing: 16) {
                        Image(.imgSaddog)
                        
                        Text("곧 추천 루트가 채워질 예정이에요\n추후에 맞춤루트를 확인하실 수 있어요!")
                            .font(.subtitle)
                            .foregroundStyle(.defaultDark)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    
                    //                    ScrollView(.horizontal, showsIndicators: false) {
                    //                        HStack(spacing: 8) {
                    //                            ForEach(1...10, id: \.self) { _ in
                    //                                  RouteCell()
                    //                            }
                    //                        }
                    //                        .padding(.trailing, 16)
                    //                    }
                    //                    .padding(.leading, 16)
                }
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            print("ACCESS TOKEN: ", AuthManager.shared.accessToken ?? "nil")
            print("REFRESH TOKEN: ", AuthManager.shared.refreshToken ?? "nil")
            print("DEVICE ID: ", DeviceIDManager.shared.getDeviceId())
        }
    }
}
