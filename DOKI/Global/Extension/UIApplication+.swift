//
//  UIApplication+.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI

extension UIApplication {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
