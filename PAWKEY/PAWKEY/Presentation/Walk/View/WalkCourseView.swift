//
//  WalkCourseView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct WalkCourseView: View {
    @EnvironmentObject var router: Coordinator<WalkScreen>
    
    @ObservedObject var viewModel: WalkCourseViewModel
    
    @Binding var showWalkCourseView: Bool
    
    @State private var showStopConfirmation = false
    
    let onComplete: (Double, String, Int, UIImage?) -> Void
    
    var body: some View {
        ZStack {
            ZStack {
                WalkMap(
                    region: $viewModel.region,
                    pathCoordinates: $viewModel.pathCoordinates,
                    shouldCenterOnUser: $viewModel.shouldCenterOnUser,
                    snapshotImage: .constant(nil)
                )
                .edgesIgnoringSafeArea(.all)
                
                if showStopConfirmation {
                    Color.pawkeyBlack.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                }
            }
            
            VStack {
                StatBox(type: .bordered, distance: viewModel.distance, elapsedTime: viewModel.elapsedTime, stepCount: viewModel.stepCount)
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                
                Spacer()
                
                if showStopConfirmation {
                    StopConfirmationView(
                        onResume: {
                            showStopConfirmation = false
                            viewModel.setPaused(false)
                        },
                        onStop: {
                            viewModel.stopTracking()
                            viewModel.captureMapSnapshot { snapshot in
                                showWalkCourseView = false
                                onComplete(
                                    viewModel.distance,
                                    viewModel.elapsedTime,
                                    viewModel.stepCount,
                                    snapshot
                                )
                            }
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
                        viewModel.setPaused(true)
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
                            viewModel.shouldCenterOnUser = true
                            viewModel.centerMapOnCurrentLocation()
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

struct StopConfirmationView: View {
    let onResume: () -> Void
    let onStop: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("산책이 중단되었어요.")
                .font(.head_24_b)
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
