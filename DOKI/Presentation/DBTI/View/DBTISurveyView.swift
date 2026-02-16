//
//  DBTISurveyView.swift
//  DOKI
//
//  Created by 안치욱 on 2/11/26.
//

import SwiftUI

struct DBTISurveyView: View {
    @ObservedObject var viewModel: DBTIViewModel

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            DBTIQuestionView(viewModel: viewModel)

            Spacer()

            MainButton(
                text: viewModel.isLastStep ? "완료" : "다음으로",
                buttonState: viewModel.buttonDisabled ? .disabled : .active1
            ) {
                if viewModel.isLastStep {
                    viewModel.complete()
                } else {
                    viewModel.goToNextStep()
                }
            }
            .padding(.horizontal, 16)
        }
        .overlay(alignment: .top) {
            progressBar
        }
        .ignoresSafeArea(.keyboard)
        .topNavigationView {
            BackButton {
                if viewModel.isFirstStep {
                    dismiss()
                } else {
                    viewModel.goToPrevStep()
                }
            }
        } center: {
            Text("프로필 설정")
                .subtitle()
        }
    }

    private var progressBar: some View {
        ProgressView(value: viewModel.progress)
            .frame(height: 2)
            .progressViewStyle(.linear)
            .tint(.defaultPrimary)
            .animation(.easeInOut, value: viewModel.currentIndex)
    }
}

