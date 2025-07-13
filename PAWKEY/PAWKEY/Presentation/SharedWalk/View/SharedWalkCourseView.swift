//
//  SharedWalkCourseView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct SharedWalkCourseView: View {
    @EnvironmentObject var router: Coordinator<WalkScreen>
    
    @ObservedObject var viewModel: SharedWalkCourseViewModel
    
    @Binding var showSharedWalkCourseView: Bool
    
    @State private var showStopConfirmation = false
    
    let onComplete: (Double, String, Int, UIImage?) -> Void
    
    var body: some View {
        ZStack {
            ZStack {
                SharedWalkMap(
                    region: $viewModel.region,
                    shouldCenterOnUser: $viewModel.shouldCenterOnUser,
                    pathCoordinates: viewModel.examplePathCoordinates
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
                            showSharedWalkCourseView = false
                            onComplete(
                                viewModel.distance,
                                viewModel.elapsedTime,
                                viewModel.stepCount,
                                nil
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
