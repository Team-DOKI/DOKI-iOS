//
//  TabBarItem.swift
//  DOKI
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

enum TabBarItem: Int, CaseIterable {
    case home
    case walk
    case recommend
    case mypage
    
    var title: String {
        switch self {
        case .home: return "홈"
        case .walk: return "산책하기"
        case .recommend: return "루트 추천"
        case .mypage: return "마이페이지"
        }
    }
    
    var normalImage: String {
        switch self {
        case .home: return "ic_home"
        case .walk: return "ic_walk"
        case .recommend: return "ic_route"
        case .mypage: return "ic_profile"
        }
    }
    
    var selectedImage: String {
        switch self {
        case .home: return "ic_home_fill"
        case .walk: return "ic_walk_fill"
        case .recommend: return "ic_route_fill"
        case .mypage: return "ic_profile_fill"
        }
    }
}
