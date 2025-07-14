//
//  MyPageScreen.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

enum MyPageScene: AppScene {
    case myPage
    case userProfile
    case petProfile
    case savedCourse
    case myCourse
    case courseDetail
    
    @ViewBuilder
    func build() -> some View {
        switch self {
        case .myPage:
            MyPageView()
        case .userProfile:
            UserProfileView()
        case .petProfile:
            PetProfileView()
        case .savedCourse:
            SavedCourseView()
        case .myCourse:
            MyCourseView()
        case .courseDetail:
            CourseDetailView(viewModel: CourseDetailViewModel())
        }
    }
}
