//
//  DBTIQuestionView.swift
//  DOKI
//
//  Created by 안치욱 on 2/11/26.
//

import SwiftUI

struct DBTIQuestionView: View {
    @ObservedObject var viewModel: DBTIViewModel

    var body: some View {
        let q = viewModel.currentQuestion
        let selectedId = viewModel.selectedOptionIDForCurrent

        VStack(spacing: 58) {
            VStack(spacing: 5) {
                Text(q.categoryName)
                    .bodyActive(color: .defaultPrimary)

                Text(q.content)
                    .header3(color: .contents)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity, minHeight: 72, alignment: .top)
            }

            HStack(spacing: 8) {
                ForEach(q.options) { opt in
                    DBTIOptionCardView(
                        option: opt,
                        isSelected: selectedId == opt.id
                    ) {
                        viewModel.optionTapped(optionId: opt.id)
                    }
                }
            }
            .padding(.horizontal, 16)

            Spacer()
        }
        .padding(.top, 60)
    }
}
