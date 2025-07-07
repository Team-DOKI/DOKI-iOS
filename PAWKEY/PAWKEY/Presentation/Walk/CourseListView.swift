//
//  CourseListView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct CourseListView: View {
    @EnvironmentObject var router: TabRouter<WalkScreen>
    @State private var selectedMode: Int = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("코스 리스트")
                .font(.title)
            
            Picker("탭", selection: $selectedMode) {
                Text("지도").tag(0)
                Text("피드").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Button("ㅋㅋ") {
                if selectedMode == 0 {
                    router.push(.walkCourse(id: 1))
                } else {
                    router.push(.sharedWalkCourse(id: 1))
                }
            }
        }
    }
}
