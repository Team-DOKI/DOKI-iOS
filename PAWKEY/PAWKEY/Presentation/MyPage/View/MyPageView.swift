//
//  MyPageView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var router: TabRouter<MyPageScreen>
    
    var body: some View {
        VStack {
            Text("마이페이지")
                .font(.head_20_b)
                .padding(.top, 20)
                .padding(.leading, 16)
            Spacer()
            Button("견주 프로필") {
                router.push(.userProfile)
            }
          
            Button("반려견 프로필") {
                router.push(.petProfile)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

