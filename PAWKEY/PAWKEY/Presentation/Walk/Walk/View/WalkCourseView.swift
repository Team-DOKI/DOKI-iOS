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
    
    var body: some View {
        ZStack {
            ZStack {
                WalkingMapView(region: $viewModel.region,
                               pathCoordinates: $viewModel.pathCoordinates,
                               shouldCenterOnUser: $viewModel.shouldCenterOnUser)
                .edgesIgnoringSafeArea(.all)
                
                if showStopConfirmation {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                }
            }
            
            VStack {
                HStack(spacing: 32) {
                    StatView(title: "거리 (km)", value: String(format: "%.1f", viewModel.distanceInKilometers))
                    StatView(title: "시간 (분)", value: viewModel.elapsedTimeString)
                    StatView(title: "걸음 수 (걸음)", value: "\(viewModel.stepCount)")
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 32)
                .frame(maxWidth: .infinity, minHeight: 84)
                .background(.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.09, green: 0.74, blue: 0.18), lineWidth: 1)
                )
                .padding(.top, 16)
                .padding(.horizontal, 23)
                
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
                        }
                    )
                } else {
                    Spacer()
                    
                    SubmitButton(
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
                            Image(systemName: "location.fill")
                                .frame(width: 44, height: 44)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 104)
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
        VStack {
            Text(title)
                .font(.caption2)
                .foregroundColor(.gray)
            Text(value)
                .font(.title3).bold()
                .foregroundColor(.green)
        }
        .frame(width: 66)
    }
}

struct StopConfirmationView: View {
    let onResume: () -> Void
    let onStop: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("산책이 중단되었어요.\n산책을 정말 종료하시겠어요?")
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 40)
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: onResume) {
                    Text("계속 산책하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.green)
                        .cornerRadius(8)
                }
                
                Button(action: onStop) {
                    Text("산책 종료하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 26)
        }
    }
}
