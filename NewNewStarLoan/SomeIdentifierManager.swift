//
//  DeviceIdentifierManager.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/28.
//


import AdSupport
import AppTrackingTransparency
import UIKit
import SwiftKeychainWrapper

class SomeIdentifierManager {
    private let keychainService: String
    
    init() {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            fatalError("Failed to retrieve bundle identifier")
        }
        self.keychainService = bundleIdentifier
    }
    
    // 获取 IDFA
    func fetchIDFA(completion: @escaping (String?) -> Void) {
        
      if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        completion(idfa)
                    } else {
                      let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                      completion(idfa)
                    }
                }
            }
        } else {
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
          completion(idfa)
        }
    }
    
    // 获取 IDFV
    func fetchIDFV() -> String? {
      fetchIDFVFromKeychain()
    }
    
    // 存储 IDFV 到 Keychain
  @discardableResult
    func storeIDFVToKeychain(idfv: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "idfvKey",
            kSecValueData as String: idfv.data(using: .utf8)!,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        // 先删除可能存在的旧数据
        SecItemDelete(query as CFDictionary)
        
        // 存储新数据
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    // 从 Keychain 中读取 IDFV
    func fetchIDFVFromKeychain() -> String? {
      let key = "save.idfv.key"
      guard let idfv = KeychainWrapper.standard.string(forKey: key) else {
          let idfv = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
          KeychainWrapper.standard.set(idfv, forKey: key)
          return idfv
      }
      return idfv

//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrService as String: keychainService,
//            kSecAttrAccount as String: "idfvKey",
//            kSecReturnData as String: kCFBooleanTrue!,
//            kSecMatchLimit as String: kSecMatchLimitOne
//        ]
//        
//        var result: AnyObject?
//        let status = SecItemCopyMatching(query as CFDictionary, &result)
//        
//        if status == errSecSuccess,
//           let data = result as? Data,
//           let string = String(data: data, encoding: .utf8) {
//            return string
//        }else {
//          let vv = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
//          storeIDFVToKeychain(idfv: vv)
//          
//          return vv
//        }
    }
}
