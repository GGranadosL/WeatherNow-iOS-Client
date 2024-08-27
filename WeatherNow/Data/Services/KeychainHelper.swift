//
//  KeychainHelper.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 25/08/24.
//

import Security
import Foundation

class KeychainHelper {
    
    /// Singleton instance to access KeychainHelper globally.
    static let shared = KeychainHelper()
    
    /// Private initializer to prevent instantiation outside of singleton.
    private init() {}
    
    /// API for app use
    func saveAPIKey(_ apiKey: String) {
        let service = "com.myapp.api"
        let account = "defaultAccount"
        saveApiKey(apiKey, service: service, account: account)
    }

    /// API for app use
    func getAPIKey() -> String? {
        let service = "com.myapp.api"
        let account = "defaultAccount"
        return readApiKey(service: service, account: account)
    }
    
    /// Saves data in the Keychain for a specific service and account.
    /// - Parameters:
    ///   - data: Data to be saved.
    ///   - service: The service identifier under which the data is stored.
    ///   - account: The account identifier under which the data is stored.
    /// - Returns: OSStatus indicating success or error.
    @discardableResult
    private func save(_ data: Data, service: String, account: String) -> OSStatus {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query) // Remove any existing item with the same service and account.
        return SecItemAdd(query, nil)
    }

    /// Reads data from the Keychain for a specific service and account.
    /// - Parameters:
    ///   - service: The service identifier from which the data is retrieved.
    ///   - account: The account identifier from which the data is retrieved.
    /// - Returns: Optional data retrieved from Keychain.
    private func read(service: String, account: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        if status == noErr, let data = result as? Data {
            return data
        }
        return nil
    }

    /// Deletes data from the Keychain for a specific service and account.
    /// - Parameters:
    ///   - service: The service identifier from which the data should be deleted.
    ///   - account: The account identifier from which the data should be deleted.
    private func delete(service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary

        SecItemDelete(query)
    }
    
    /// Convenience method to save an API key in the Keychain.
    /// - Parameters:
    ///   - apiKey: The API key as a String.
    ///   - service: The service identifier under which the API key is stored.
    ///   - account: The account identifier under which the API key is stored.
    private func saveApiKey(_ apiKey: String, service: String, account: String) {
        if let data = apiKey.data(using: .utf8) {
            _ = save(data, service: service, account: account)
        }
    }

    /// Convenience method to read an API key from the Keychain.
    /// - Parameters:
    ///   - service: The service identifier from which the API key is retrieved.
    ///   - account: The account identifier from which the API key is retrieved.
    /// - Returns: Optional String containing the API key.
    private func readApiKey(service: String, account: String) -> String? {
        if let data = read(service: service, account: account) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

