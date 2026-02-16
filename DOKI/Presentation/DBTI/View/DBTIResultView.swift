//
//  DBTIResultView.swift
//  DOKI
//
//  Created by 안치욱 on 2/14/26.
//

import SwiftUI

struct DBTIResultView: View {
    @ObservedObject var viewModel: DBTIResultViewModel

    var body: some View {
        VStack(spacing: 0) {

            DBTIResultCardView(result: viewModel.result)
                .padding(.horizontal, 16)
                .padding(.top, 20)

            Spacer()

            DBTIResultBottomButtonsView(
                showsHomeButton: viewModel.showsHomeButton,
                onRestart: viewModel.restartTapped,
                onHome: viewModel.homeTapped
            )
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .background(Color.defaultBright.ignoresSafeArea())
        .topNavigationView {
            BackButton {
                
            }
        } center: {
            Text("DBTI 결과")
                .subtitle()
        }
    }
}
