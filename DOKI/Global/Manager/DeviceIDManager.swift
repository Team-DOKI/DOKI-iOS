//
//  DeviceIDManager.swift
//  DOKI
//
//  Created by 이세민 on 1/17/26.
//

import Foundation

final class DeviceIDManager {
    static let shared = DeviceIDManager()
    
    private let deviceIdKey = KeychainName.deviceId
    
    private init() {}
    
    func getDeviceId() -> String {
        if let storedId = try? KeychainManager.read(deviceIdKey) {
            return storedId.replacingOccurrences(of: "\"", with: "")
        }
        
        let newId = UUID().uuidString
        try? KeychainManager.create(deviceIdKey, newId)
        return newId
    }
}
