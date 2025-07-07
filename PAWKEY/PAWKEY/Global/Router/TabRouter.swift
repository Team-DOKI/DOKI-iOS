//
//  TabRouter.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

public final class TabRouter<Screen: Hashable>: ObservableObject {
    
    @Published var path = NavigationPath()
    
    @MainActor
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    @MainActor
    func pop() {
        path.removeLast()
    }
    
    @MainActor
    func reset() {
        path.removeLast(path.count)
    }
}
