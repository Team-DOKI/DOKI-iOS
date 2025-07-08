//
//  WalkCourseView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct WalkCourseView: View {
    @EnvironmentObject var router: TabRouter<WalkScreen>
    
    @ObservedObject var viewModel: WalkCourseViewModel
    
    @Binding var showWalkCourseView: Bool
    
    @State private var showStopConfirmation = false
    
    let onComplete: (Double, String, Int) -> Void
    
    var body: some View {
        ZStack {
            ZStack {
                WalkingMapView(region: $viewModel.region,
                               pathCoordinates: $viewModel.pathCoordinates,
                               shouldCenterOnUser: $viewModel.shouldCenterOnUser)
                .edgesIgnoringSafeArea(.all)
                
                if showStopConfirmation {
                    Color.pawkeyBlack.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                }
            }
            
            VStack {
                HStack(spacing: 36) {
                    StatView(title: "거리 (km)", value: String(format: "%.1f", viewModel.distance))
                    StatView(title: "시간 (분)", value: viewModel.elapsedTime)
                    StatView(title: "걸음 수 (걸음)", value: "\(viewModel.stepCount)")
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 32)
                .frame(maxWidth: .infinity, minHeight: 74)
                .background(.pawkeyWhite1)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .inset(by: 0.5)
                        .stroke(.green500, lineWidth: 1)
                )
                .padding(.top, 24)
                .padding(.horizontal, 16)
                
                Spacer()
                
                if showStopConfirmation {
                    StopConfirmationView(
                        onResume: {
                            showStopConfirmation = false
                            viewModel.resumeTracking()
                        },
                        onStop: {
                            viewModel.stopTracking()
                            showWalkCourseView = false
                            onComplete(
                                viewModel.distance,
                                viewModel.elapsedTime,
                                viewModel.stepCount
                            )
                        }
                    )
                } else {
                    Spacer()
                    
                    CTAButton(
                        title: "종료하기",
                        isDisabled: false,
                        buttonStyle: .filled
                    ) {
                        showStopConfirmation = true
                        viewModel.pauseTracking()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 26)
                }
            }
            
            if !showStopConfirmation {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.centerMapOnCurrentLocation()
                            viewModel.shouldCenterOnUser = true
                        }) {
                            Image(.mapGps)
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 102)
                    }
                }
            }
        }
        .onAppear {
            viewModel.startTracking()
        }
    }
}

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption_12_sb)
                .foregroundColor(.gray500)
            
            Text(value)
                .font(.head_20_b)
                .foregroundColor(.green500)
        }
        .frame(width: 67, height: 42)
    }
}

struct StopConfirmationView: View {
    let onResume: () -> Void
    let onStop: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("산책이 중단되었어요.")
                .font(.head_22_b) // 24 추가해야 함
                .foregroundColor(.pawkeyWhite1)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 88)
                .padding(.bottom, 12)
            
            Text("산책을 정말 종료하시겠어요?")
                .font(.body_16_m)
                .foregroundColor(.pawkeyWhite2)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 96)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: onResume) {
                    Text("계속 산책하기")
                        .font(.body_16_sb)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.pawkeyWhite1)
                        .foregroundColor(.green500)
                        .cornerRadius(8)
                }
                
                Button(action: onStop) {
                    Text("산책 종료하기")
                        .font(.body_16_sb)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.green500)
                        .foregroundColor(.pawkeyWhite1)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 26)
        }
    }
}
