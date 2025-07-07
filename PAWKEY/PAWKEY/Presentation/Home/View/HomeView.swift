//
//  HomeView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: TabRouter<HomeScreen>
    
    var body: some View {
        VStack {
            Text("홈 화면").font(.largeTitle)
            Button("동네 변경") {
                router.push(.changeMyArea)
            }
        }
    }
}
