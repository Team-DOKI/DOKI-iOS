//
//  LoginViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var idText = ""
    @Published var passwordText = ""
    
    var isDisabled: Bool {
        idText.isEmpty || passwordText.isEmpty
    }
}
