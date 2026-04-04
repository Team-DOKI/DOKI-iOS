//
//  DBTIResultView.swift
//  DOKI
//
//  Created by 안치욱 on 2/14/26.
//

import SwiftUI

struct DBTIResultView: View {
    @ObservedObject var viewModel: DBTIViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            DBTIResultCard(
                dbtiName: viewModel.dbtiName,
                type: viewModel.type,
                imageUrl: viewModel.resultImageUrl,
                keywords: viewModel.keywords,
                description: viewModel.description,
                analysis: viewModel.analysis
            )
            .padding(.top, 20)
            
            Spacer()
            
            if viewModel.dbtiEntryContext == .afterRegister {
                HStack(spacing: 8) {
                    MainButton(
                        text: "다시 테스트하기",
                        buttonState: .active2
                    ) {
                        viewModel.restartDBTI()
                    }
                    
                    MainButton(
                        text: "홈으로 가기",
                        buttonState: .active1
                    ) {
                        viewModel.finishDBTI()
                    }
                }
                .padding(.bottom, 12)
                
            } else {
                MainButton(
                    text: "다시 테스트하기",
                    buttonState: .active1
                ) {
                    viewModel.restartDBTI()
                }
                .padding(.bottom, 12)
            }
        }
        .padding(.horizontal, 16)
        .background(Color.defaultBright.ignoresSafeArea())
        .topNavigationView {
            BackButton {
                viewModel.navigationAction?(.dbtiFinish)
            }
        } center: {
            Text("DBTI 결과")
                .subtitle()
        }
        .onAppear {
            if viewModel.dbtiEntryContext == .myPage {
                viewModel.fetchDBTIResult(petId: 19)
            }
        }
    }
}
