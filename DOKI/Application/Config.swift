//
//  Config.swift
//  DOKI
//
//  Created by 이세민 on 7/14/25.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let BASE_URL = "BASE_URL"
            static let NAVER_CLIENT_ID = "NAVER_CLIENT_ID"
            static let KAKAO_NATIVE_APP_KEY = "KAKAO_NATIVE_APP_KEY"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found")
        }
        return dict
    }()
}

extension Config {
    static let baseURL: String = {
        guard let url = Config.infoDictionary[Keys.Plist.BASE_URL] as? String else {
            fatalError("BASE_URL is not set in plist")
        }
        return "https://" + url
    }()
    
    static let naverClientID: String = {
        guard let id = Config.infoDictionary[Keys.Plist.NAVER_CLIENT_ID] as? String else {
            fatalError("NAVER_CLIENT_ID is not set in plist")
        }
        return id
    }()
    
    static let kakaoNativeAppKey: String = {
        guard let id = Config.infoDictionary[Keys.Plist.KAKAO_NATIVE_APP_KEY] as? String else {
            fatalError("KAKAO_NATIVE_APP_KEY is not set in plist")
        }
        return id
    }()
}
