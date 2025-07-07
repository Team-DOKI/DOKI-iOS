//
//  WalkCourseView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct WalkCourseView: View {
    @EnvironmentObject var router: TabRouter<WalkScreen>
    let courseId: Int
    
    var body: some View {
        Text("산책 중: \(courseId)")
        
        Button("산책 완료") {
            router.push(.walkCompletion(id: courseId))
        }
    }
}
