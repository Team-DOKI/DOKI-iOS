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
                    MyProfile()
                        .onTapGesture {
                            print("프로필 수정")
                        }
                    PetProfile()
                        .onTapGesture {
                            print("반려견 프로필 수정")
                        }
                    WalkRouteManage()
                    Setting()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 22)
            }
        }
    }
}

#Preview {
    MyPageView(viewModel: MyPageViewModel())
}
