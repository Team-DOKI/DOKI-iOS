//
//  SplashView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct SplashView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIStoryboard(name: "Launch Screen", bundle: nil).instantiateInitialViewController()!
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
