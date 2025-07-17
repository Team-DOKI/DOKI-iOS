//
//  CourseDetailWrapperView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/17/25.
//

import SwiftUI

struct CourseDetailWrapperView: View {
    @EnvironmentObject var coordinator: Coordinator<WalkScene>
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @ObservedObject var viewModel: CourseDetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CourseDetailView(viewModel: viewModel) {
                coordinator.popToRoot()
                mainTabViewModel.isHidden = false
            }
            .overlay(alignment: .bottom) {
            
                if let post = viewModel.post, post.author.id != 2 {
                    Button(action: {
                        viewModel.isShowSharedWalkCourseView = true
                    }) {
                        Text("해당 루트로 산책하기")
                            .font(.body_16_sb)
                            .foregroundStyle(.pawkeyWhite1)
                            .frame(maxWidth: .infinity, minHeight: 56)
                    }
                    .background(.green500)
                }
            }
            .onAppear {
                mainTabViewModel.isHidden = true
            }
        }
    }
}

