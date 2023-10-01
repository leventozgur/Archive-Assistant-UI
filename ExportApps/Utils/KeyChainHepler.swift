//
//  KeyChainHepler.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 20.09.2023.
//

import Foundation

final class KeyChainHepler {
    static let shared = KeyChainHepler()

    private init() { }

}

extension KeyChainHepler {
    func saveUserCredentials(data: String) -> Result<Void, KeyChainErrors> {
        DispatchQueue.global().sync {
            let query: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: StaticVeriables.keychainServiceName as AnyObject,
                kSecValueData as String: data.data(using: .utf8) as AnyObject,
            ]

            let status = SecItemAdd(query as CFDictionary, nil)

            switch status {
            case errSecSuccess:
                return  .success(())
            case errSecDuplicateItem:
                return .failure(KeyChainErrors.duplicateEntry)
            default:
                return .failure(KeyChainErrors.unkown) 
            }
        }
    }
    
    func getUserCredentials() -> Result<String, KeyChainErrors> {
        DispatchQueue.global().sync {
            let query = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: StaticVeriables.keychainServiceName as AnyObject,
                kSecReturnData as String: kCFBooleanTrue,
                kSecMatchLimit as String: kSecMatchLimitOne
            ] as CFDictionary

            var result: AnyObject?
            SecItemCopyMatching(query as CFDictionary, &result)
            
            guard let result = result as? Data else { return .failure(KeyChainErrors.unkown) }
            let password = String(decoding: result, as: UTF8.self)
            return .success(password)
        }
    }
    
    func updateUserCredentials(newData: String) -> Result<Void, KeyChainErrors> {
        DispatchQueue.global().sync {
            let query = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: StaticVeriables.keychainServiceName as AnyObject
            ] as CFDictionary

            let attributesToUpdate = [
                kSecValueData as String: newData.data(using: .utf8) as AnyObject,
            ] as CFDictionary

            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

            switch status {
            case errSecSuccess:
                return .success(())
            case errSecDuplicateItem:
                return .failure(KeyChainErrors.duplicateEntry)
            default:
                return .failure(KeyChainErrors.unkown)
            }
        }
    }
    
    func deleteUserCredentials() -> Result<Void, KeyChainErrors> {
        DispatchQueue.global().sync {
            let query = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: StaticVeriables.keychainServiceName as AnyObject
            ] as CFDictionary

            let status = SecItemDelete(query as CFDictionary)

            switch status {
            case errSecSuccess:
                return .success(())
            case errSecDuplicateItem:
                return .failure(KeyChainErrors.duplicateEntry)
            default:
                return .failure(KeyChainErrors.unkown)
            }
        }
    }
}
