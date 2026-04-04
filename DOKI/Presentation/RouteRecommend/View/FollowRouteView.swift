//
//  FollowRouteView.swift
//  DOKI
//
//  Created by 이세민 on 3/12/26.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct FollowRouteView: View {
    @StateObject var viewModel: FollowRouteViewModel
    
    @State private var isLocationOn = false // 추후 위치 공유
    @State private var confirmType: WalkConfirmType?
    
    var body: some View {
        ZStack() {
            FollowRouteNaverMapView(
                pathCoordinates: viewModel.pathCoordinates,
                userTrackingMode: $viewModel.userTrackingMode
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // 추후 위치 공유
                HStack(spacing: 0) {
                    Spacer()
                    
                    Toggle("", isOn: $isLocationOn)
                        .labelsHidden()
                        .padding(.trailing, 16)
                }
                .padding(.top, 20)
                .opacity(0)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    VStack(spacing: 12) {
                        PinButton(icon: "ic_trash", action: {}).opacity(0) // 추후 스팟 태그
                        
                        PinButton(icon: "ic_photo", action: {}).opacity(0) // 추후 스팟 태그
                        
                        PinButton(icon: "ic_gps", action: {
                            viewModel.userTrackingMode.toggle()
                        })
                    }
                    .padding(.trailing, 16)
                }
                .padding(.bottom, 14)
                
                VStack(spacing: 12) {
                    Spacer().frame(height: 44)
                    
                    HStack(spacing: 0) {
                        WalkStatItem(title: "거리 (km)", value: viewModel.distanceString)
                        WalkStatItem(title: "시간 (분)", value: viewModel.elapsedTimeString)
                        WalkStatItem(title: "걸음 수 (걸음)", value: viewModel.stepString)
                    }
                    .padding(.bottom, 20)
                    
                    HStack(spacing: 8) {
                        MainButton(text: "산책 중단하기", buttonState: .active2, size: .medium) {
                            viewModel.pauseTimer()
                            confirmType = .pause
                        }
                        
                        MainButton(text: "산책 종료하기", buttonState: .active1, size: .medium) {
                            viewModel.pauseTimer()
                            confirmType = .finish
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
                .background(.defaultBackground)
                .cornerRadius(16, corners: [.topLeft, .topRight])
                .shadow(color: .contents.opacity(0.15), radius: 6, x: 0, y: -2)
            }
            .ignoresSafeArea(edges: .bottom)
            
            if let type = confirmType {
                WalkConfirmOverlay(
                    title: type == .pause ? "산책이 중단되었어요" : "산책을 종료하시겠어요?",
                    message: type == .pause
                    ? "정비 후에 다시 이어서 산책을 해 보세요!"
                    : "종료 후에는 산책 기록을 이어갈 수 없어요!",
                    leftButtonText: type == .pause
                    ? "이어서 하기" : "아니오",
                    rightButtonText: type == .pause ? "산책 종료하기" : "예",
                    onLeftAction: {
                        viewModel.resumeTimer()
                        withAnimation {
                            confirmType = nil
                        }
                    },
                    onRightAction: {
                        viewModel.finishFollow()
                    }
                )
            }
        }
        .onAppear {
            viewModel.startTimer()
            viewModel.fetchRouteGeometry()
        }
    }
}
