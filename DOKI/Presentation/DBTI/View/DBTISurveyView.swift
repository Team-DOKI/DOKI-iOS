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
            if let question = viewModel.currentQuestion {
                DBTIQuestion(
                    data: question,
                    selectedIndex: $viewModel.selectedIndex
                )
            }
            
            Spacer()
            
            MainButton(
                text: viewModel.isLastStep ? "완료" : "다음으로",
                buttonState: viewModel.buttonDisabled ? .disabled : .active1
            ) {
                viewModel.goToNextStep(petId: 14)
            }
            .padding(.horizontal, 16)
        }
        .overlay(alignment: .top) {
            ProgressView(value: viewModel.progress)
                .frame(height: 2)
                .tint(.defaultPrimary)
        }
        .topNavigationView {
            BackButton {
                if viewModel.isFirstStep {
                    dismiss()
                } else {
                    viewModel.goToPrevStep()
                }
            }
        } center: {
            Text("DBTI")
                .subtitle()
        }
    }
}

