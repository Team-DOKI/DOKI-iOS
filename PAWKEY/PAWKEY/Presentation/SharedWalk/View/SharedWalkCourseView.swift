//
//  SharedWalkCourseView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI
import MapKit

struct SharedWalkCourseView: View {
    @EnvironmentObject var coordinator: Coordinator<WalkScene>
    
    @ObservedObject var viewModel: SharedWalkCourseViewModel
    
    @Binding var showSharedWalkCourseView: Bool
    
    @State private var showStopConfirmation = false
    
    @State private var userTrackingMode: MKUserTrackingMode = .none
    
    let routeId: Int
    
    let onComplete: (Double, String, Int, Int) -> Void
        
    
    var body: some View {
        ZStack {
            ZStack {
                SharedWalkMap(
                    region: $viewModel.region,
                    shouldCenterOnUser: $viewModel.shouldCenterOnUser,
                    userTrackingMode: $userTrackingMode,
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
                        description: "아직 설정된 산책 루트를 다 돌지 못했어요.",
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
                                routeId
                            )
                        }
                    )
                } else {
                    Spacer()
                    
                    CTAButton(
                        title: "산책 기록 중지",
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
            
            Task {
                await viewModel.fetchSharedWalkCourses(routeId: routeId)
            }
        }
    }
}
