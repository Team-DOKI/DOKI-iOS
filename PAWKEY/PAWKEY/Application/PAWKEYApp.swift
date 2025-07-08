//
//  PAWKEYApp.swift
//  PAWKEY
//
//  Created by 이세민 on 6/21/25.
//

import SwiftUI

@main
struct PAWKEYApp: App {
    @State var isExpanded: Bool = false
    @State var isExpanded2: Bool = false
    var body: some Scene {
        WindowGroup {
            VStack {
                AccordionView(isExpanded: $isExpanded, title: "산책 소요 시간", items: ["20분 이내", "21-40분", "41-60분", "1시간 이상"])
                Divider()
                AccordionView(isExpanded: $isExpanded2, title: "산책 소요 시간", items: ["20분 이내", "21-40분", "41-60분", "1시간 이상"])
            }
//            TabView()
//                .onAppear {
//                    LocationManager.shared.requestLocationPermission()
//                }
        }
    }
}
