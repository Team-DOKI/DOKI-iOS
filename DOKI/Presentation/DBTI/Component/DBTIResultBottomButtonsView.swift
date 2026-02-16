//
//  DBTIResultBottomButtonsView.swift
//  DOKI
//
//  Created by 안치욱 on 2/16/26.
//

import SwiftUI

struct DBTIResultBottomButtonsView: View {

    let showsHomeButton: Bool
    let onRestart: () -> Void
    let onHome: () -> Void

    var body: some View {
        Group {
            if showsHomeButton {
                HStack(spacing: 8) {
                    MainButton(text: "다시 테스트하기", buttonState: .active2) {
                        onRestart()
                    }

                    MainButton(text: "홈으로 가기", buttonState: .active1) {
                        onHome()
                    }
                }
            } else {
                MainButton(text: "다시 테스트하기", buttonState: .active1) {
                    onRestart()
                }
            }
        }
    }
}
