//
//  TabBarItem.swift
//  PAWKEY
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

enum TabBarItem: CaseIterable {
    case home, walk, community, mypage

    var normalImage: Image {
        switch self {
        case .home: return Image(systemName: "house")
        case .walk: return Image(systemName: "pawprint")
        case .community: return Image(systemName: "person.3")
        case .mypage: return Image(systemName: "person.crop.circle")
        }
    }

    var selectedImage: Image {
        switch self {
        case .home: return Image(systemName: "house.fill")
        case .walk: return Image(systemName: "pawprint.fill")
        case .community: return Image(systemName: "person.3.fill")
        case .mypage: return Image(systemName: "person.crop.circle.fill")
        }
    }
}
