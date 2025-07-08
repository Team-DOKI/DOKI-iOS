//
//  ScreenEnum.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import Foundation

enum HomeScreen: Hashable {
    case home
    case changeMyArea
}

enum WalkScreen: Hashable {
    case courseList
    case courseDetail(CourseDetailViewModel)

//    case walkCourse()
    case walkCompletion(distance: Double, elapsedTime: String, stepCount: Int)
    case archive
    
    case sharedWalkCourse(id: Int)
    case sharedWalkCompletion(id: Int)
    case reviewWrite(id: Int)
}

enum MyPageScreen: Hashable {
    case myPage
    case userProfile
    case petProfile
}
