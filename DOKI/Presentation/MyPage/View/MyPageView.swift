//
//  MyPageView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject var viewModel: MyPageViewModel
    
    var body: some View {
        ZStack {
            Color.defaultBright.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    MyProfile(
                        nickname: "키큰오팔전차",
                        email: "hello@gmail.com",
                        action: {}
                    )
                    
                    PetProfile()

                    WalkRouteManage()
                    Setting()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 22)
            }
        }
        .topNavigationView(center: {
            Text("마이페이지")
                .subtitle()
        })
    }
}

#Preview {
    MyPageView(viewModel: MyPageViewModel())
}
