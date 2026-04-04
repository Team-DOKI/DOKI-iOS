//
//  WithdrawReasonView.swift
//  DOKI
//
//  Created by 권석기 on 3/9/26.
//

import SwiftUI

struct WithdrawReasonView: View {
    let checkItems: [CheckItem]
    @Binding var selectedItem: CheckItem?
    
    let primaryButtonAction: () -> Void
    let secondaryButtonAction: () -> Void
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("어떤 이유로 탈퇴하시나요?")
                    .mainActive()
                    .padding(.top, 16)
                Text("도키가 더 좋아질 수 있도록 이유를 알려주세요.")
                    .bodyDefault(color: .defaultMiddle)
                    .padding(.top, 2)
                
                VStack {
                    ForEach(checkItems, id: \.self.id) { item in
                        HStack {
                            Image(selectedItem == item ? .btnSelected : .btnNotselected)
                            Text(item.text)
                                .bodyDefault(color: .defaultDark)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .leading)
                        .onTapGesture {
                            selectedItem = item
                        }
                    }
                }
                .padding(.top, 16)
                
                HStack(spacing: 9) {
                    MainButton(text: "다음 단계로", buttonState: .normal, size: .medium, action: secondaryButtonAction)
                        .onTapGesture(perform: secondaryButtonAction)
                    
                    MainButton(text: "더 써볼래요", size: .medium, action: primaryButtonAction)
                }
                .padding(.top, 16)
            }
            .padding(16)
        }
        .background(.white)
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }
}
