//
//  PKAlertButton.swift
//  PAWKEY
//
//  Created by 권석기 on 7/5/25.
//

import SwiftUI

struct PKAlertButton: View {
    
    enum PKAlertButtonType {
        case confirm
        case cancel
        
        var backgroundColor: Color {
            switch self {
            case .confirm:
                return .green
            case .cancel:
                return .red
            }
        }
        
        var textColor: Color {
            switch self {
            case .confirm:
                .white
            case .cancel:
                .white
            }
        }
    }
    
    @Binding var isPresented: Bool
    
    let buttonTitle: String
    let buttonType: PKAlertButtonType
    let action: (() -> Void)?
    
    var body: some View {
        Button {
            self.isPresented = false
            action?()
        } label: {
            Text(buttonTitle)
                .foregroundStyle(buttonType.textColor)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(buttonType.backgroundColor)
    }
}

#Preview {
    PKAlertButton(isPresented: .constant(true), buttonTitle: "확인", buttonType: .confirm, action: nil)
}
