//
//  Config.swift
//  PAWKEY
//
//  Created by 이세민 on 7/14/25.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let BASE_URL = "BASE_URL"
            static let NAVER_CLIENT_ID = "NAVER_CLIENT_ID"
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
        guard let key = Config.infoDictionary[Keys.Plist.BASE_URL] as? String else {
            fatalError("BASE_URL is not set in plist for this configuration")
        }
        return "https://" + key
    }()
    
    static let naverClientID: String = {
        guard let id = Config.infoDictionary[Keys.Plist.NAVER_CLIENT_ID] as? String else {
            fatalError("NAVER_CLIENT_ID is not set in plist")
        }
        return id
    }()
}
