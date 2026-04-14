//
//  KeychainManager.swift
//  DOKI
//
//  Created by a on 12/7/25.
//

import Foundation

enum KeychainError: Error {
    case noPassword
    case unhandledError(status: OSStatus)
    case unexpectedPasswordData
    
    var message: String {
        switch self {
        case .noPassword: return "No password available."
        case .unexpectedPasswordData: return "Expected data, but found none."
        case .unhandledError(let status): return "Unhandled error with status: \(status)"
        }
    }
}

enum KeychainName: String {
    case accessToken
    case refreshToken
    case deviceId
    case petId
    case userId
    case provider
}

struct KeychainManager {
    
    /// Keychain 저장소에서 key에 해당하는 값을 추가
    static func create(_ key: KeychainName, _ value: String) throws {
        let valueData = value.data(using: .utf8)!
        
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: valueData
        ]
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    /// Keychain 저장소에서 key에 해당하는 값을 검색
    @discardableResult
    static func read(_ key: KeychainName) throws -> String? {
        let query: NSDictionary = [kSecClass: kSecClassGenericPassword,
                             kSecAttrAccount: key.rawValue,
                              kSecMatchLimit: kSecMatchLimitOne,
                              kSecReturnData: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        if status == errSecSuccess {
            if let retrievedItem = item as? Data {
                let returnValue = String(data: retrievedItem, encoding: String.Encoding.utf8)
                return returnValue
            } else {
                return nil
            }
        } else {
            throw KeychainError.unexpectedPasswordData
        }
    }
    
    /// key에 해당하는 값을 삭제
    static func delete(_ key: KeychainName) throws {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ]
        let status = SecItemDelete(query)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
}
