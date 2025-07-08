//
//  TabBarState.swift
//  PAWKEY
//
//  Created by 이세민 on 7/8/25.
//

import SwiftUI

final class TabBarState: ObservableObject {
    @Published var selectedTab: TabBarItem = .home
    @Published var isHidden: Bool = false
}
