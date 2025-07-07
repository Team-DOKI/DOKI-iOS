//
//  SharedWalkCompletionView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct SharedWalkCompletionView: View {
    @EnvironmentObject var router: TabRouter<WalkScreen>
    let sharedWalkId: Int
    
    var body: some View {
        Text("공유 산책 완료: \(sharedWalkId)")
        
        Button("후기 작성하기") {
            router.push(.reviewWrite(id: sharedWalkId))
        }
    }
}
