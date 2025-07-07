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
    
    var body: some View {
        ZStack {
            WalkingMapView(region: $viewModel.region,
                           pathCoordinates: $viewModel.pathCoordinates,
                           shouldCenterOnUser: $viewModel.shouldCenterOnUser)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack(spacing: 32) {
                    VStack {
                        Text("거리 (km)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text(String(format: "%.1f", viewModel.distanceInKilometers))
                            .font(.title3).bold()
                            .foregroundColor(.green)
                    }
                    .frame(width: 66)
                    
                    VStack {
                        Text("시간 (분)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text(viewModel.elapsedTimeString)
                            .font(.title3).bold()
                            .foregroundColor(.green)
                    }
                    .frame(width: 66)
                    
                    VStack {
                        Text("걸음 수 (걸음)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text("\(viewModel.stepCount)")
                            .font(.title3).bold()
                            .foregroundColor(.green)
                    }
                    .frame(width: 66)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 32)
                .frame(maxWidth: .infinity, minHeight: 84)
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.09, green: 0.74, blue: 0.18), lineWidth: 1)
                )
                .padding(.top, 16)
                .padding(.horizontal, 23)
                
                Spacer()
                
                SubmitButton(
                    title: "종료하기",
                    isDisabled: false,
                    buttonStyle: .filled
                ) {
                    viewModel.stopTracking()
                    showWalkCourseView = false
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 26)
            }
        }
        .onAppear {
            viewModel.startTracking()
        }
    }
}
