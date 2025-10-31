//
//  ToastMessage.swift
//  PAWKEY
//
//  Created by 이세민 on 7/10/25.
//

import SwiftUI

struct ToastMessage: View {
    let message: String
    
    var body: some View {
        Text(message)                 
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .cornerRadius(10)
    }
}
