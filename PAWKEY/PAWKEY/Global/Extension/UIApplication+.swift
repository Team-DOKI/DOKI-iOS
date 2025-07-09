//
//  UIApplication+.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI

extension UIApplication {
    func hideKeyboard() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        window.addGestureRecognizer(tapRecognizer)
    }
}
