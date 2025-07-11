//
//  SharedWalkCourseView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct SharedWalkCourseView: View {
    @EnvironmentObject var router: Coordinator<WalkScreen>
    let sharedCourseId: Int
    
    var body: some View {
        Text("공유 산책 경로: \(sharedCourseId)")
        
        Button("공유 산책 완료") {
            router.push(.sharedWalkCompletion(id: sharedCourseId))
        }
    }
}
