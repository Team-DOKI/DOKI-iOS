//
//  Coordinator.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

protocol AppScene: Hashable {
    associatedtype Scene: View
    func build() -> Scene
}

protocol CoordinatorProtocol: ObservableObject {
    func push(_ scene: any AppScene)
    func pop()
    func popToRoot()
}

final class Coordinator<Scene: AppScene>: CoordinatorProtocol {
    
    @Published var path = NavigationPath()
    
    func push(_ scene: any AppScene) {
        path.append(scene)
    }
        
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
