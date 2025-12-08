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

struct KeychainManager {
    /// Keychain 저장소에서 key에 해당하는 값을 추가
    static func create(_ key: String, _ value: String) throws {
        guard let valueData = value.data(using: .utf8) else { throw KeychainError.unexpectedPasswordData }
        
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: valueData
        ]
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    
    /// Keychain 저장소에서 key에 해당하는 값을 검색
    static func read(_ key: String) throws -> String? {
        let query: NSDictionary = [kSecClass: kSecClassGenericPassword,
                                  kSecAttrAccount: key,
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
    static func delete(_ key: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        SecItemDelete(query)
    }
}
