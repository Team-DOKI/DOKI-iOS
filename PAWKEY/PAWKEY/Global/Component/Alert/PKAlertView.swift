//
//  PKAlertView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/5/25.
//

import SwiftUI

struct PKAlertView: View {
    var title: String?
    let content: String
    
    let confirmButton: PKAlertButton
    let cancelButton: PKAlertButton
    
    var body: some View {
        VStack {
            if let title {
                Text(title)
            }
            Text(content)
            HStack {
                confirmButton
                cancelButton
            }
        }
    }
}

//#Preview {
//    PKAlertView(title: "", content: "")
//}
