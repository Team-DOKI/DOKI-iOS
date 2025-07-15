//
//  WalkCourseView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI
import MapKit

struct WalkCourseView: View {
    @EnvironmentObject var coordinator: Coordinator<WalkScene>
    
    @StateObject var viewModel: WalkCourseViewModel
    @Binding var showWalkCourseView: Bool
    
    @State private var showStopConfirmation = false
    @State private var userTrackingMode: MKUserTrackingMode = .follow

    let onComplete: (Double, String, Int, UIImage?) -> Void

    var body: some View {
        ZStack {
            ZStack {
                WalkMap(
                    region: $viewModel.region,
                    pathCoordinates: $viewModel.pathCoordinates,
                    shouldCenterOnUser: $viewModel.shouldCenterOnUser,
                    userTrackingMode: $userTrackingMode
                )
                .edgesIgnoringSafeArea(.all)
                
                if showStopConfirmation {
                    Color.pawkeyBlack.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                }
            }

            VStack {
                StatBox(
                    type: .bordered,
                    distance: viewModel.distance,
                    elapsedTime: viewModel.elapsedTime,
                    stepCount: viewModel.stepCount
                )
                .padding(.top, 24)
                .padding(.horizontal, 16)

                Spacer()

                if showStopConfirmation {
                    StopConfirmationView(
                        description: "산책을 정말 종료하시겠어요?",
                        onResume: {
                            showStopConfirmation = false
                            viewModel.setPaused(false)
                        },
                        onStop: {
                            Task {
                                viewModel.stopTracking()
                                
                                let snapshot = await withCheckedContinuation { continuation in
                                    viewModel.captureMapSnapshot { image in
                                        continuation.resume(returning: image)
                                    }
                                }

                                let routeId = await viewModel.postWalkCourse(userId: 1234, snapshotImage: snapshot)
                            
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
