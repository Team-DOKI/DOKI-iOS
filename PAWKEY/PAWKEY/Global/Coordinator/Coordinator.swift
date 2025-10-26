//
//  Coordinator.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

protocol Route: Hashable, Identifiable {}

extension Route {
    var id: Self { self }
}

final class Coordinator<Page: Route>: ObservableObject {
    @Published var path = NavigationPath()
    @Published var fullScreenCover: Page?
    @Published var fullScreenPath = NavigationPath()
    
    func push(_ page: Page) {
        if fullScreenCover != nil {
            fullScreenPath.append(page)
        } else {
            path.append(page)
        }
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func presentFullScreen(_ page: Page) {
        fullScreenCover = page
    }
    
    func dismiss() {
        fullScreenCover = nil
    }
    
    func clearStack() {
        fullScreenPath.removeLast(fullScreenPath.count)
    }
}
