//
//  WalkCompletionView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct WalkCompletionView: View {
    @EnvironmentObject var router: TabRouter<WalkScreen>
    let courseId: Int
    
    var body: some View {
        Text("산책 완료: \(courseId)")
        
        Button("기록하기") {
            router.push(.archive(id: courseId))
        }
    }
}
