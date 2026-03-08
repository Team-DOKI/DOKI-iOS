//
//  AppDelegate.swift
//  DOKI
//
//  Created by 이세민 on 12/12/25.
//

import UIKit

import NMapsMap
import KakaoSDKCommon
import KakaoSDKAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        NMFAuthManager.shared().ncpKeyId = Config.naverClientID
        KakaoSDK.initSDK(appKey: Config.kakaoNativeAppKey)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
}
