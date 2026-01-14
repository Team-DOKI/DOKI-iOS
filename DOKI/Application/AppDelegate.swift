//
//  AppDelegate.swift
//  DOKI
//
//  Created by 이세민 on 12/12/25.
//

import UIKit
import NMapsMap

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        NMFAuthManager.shared().ncpKeyId = Config.naverClientID
 
        return true
    }
}
