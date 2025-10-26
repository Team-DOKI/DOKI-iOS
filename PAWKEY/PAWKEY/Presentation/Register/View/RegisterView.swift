//
//  RegisterView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Button {
            authManager.login()
        } label: {
            Text("가입완료")
        }
    }
}

#Preview {
    RegisterView()
}
