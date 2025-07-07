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
