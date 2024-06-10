//
//  Constant.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/9.
//

import Foundation
import UIKit

class Constant {
    public static let shared = Constant()
    
    @Keychain(key: .deviceUUID) private(set) var deviceUUID: String?
    
    @UserDefault(key: .isKeychainInit) var isKeychainInit: Bool?
    @UserDefault(key: .oldPreferredLanguage) var oldPreferredLanguage: String?
    @UserDefault(key: .userSetLanguage) var userSetLanguage: String?
    
    public private(set) lazy var langage: Language = {
        guard let userSetLanguage = userSetLanguage else {
            return .init(lprojId: Bundle.main.preferredLocalizations.first)
        }
        return .init(lprojId: userSetLanguage)
    }()
}

//MARK: - Public Func
extension Constant {
    public func initData() {
        if isKeychainInit == true, let uuid = deviceUUID, !uuid.isEmpty { }
        else if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            // 無 uuid 清空 keychain
            KeychainItem.removeAllKeychain()
            deviceUUID = uuid
            isKeychainInit = true
        }
        
        checkPreferredLanguageChanged()
    }
    
    public func change(language: Language) {
        self.langage = language
        userSetLanguage = language.lprojId
    }
    public func checkPreferredLanguageChanged() {
        let preferredlanguage = Bundle.main.preferredLocalizations.first
        guard
            let language = preferredlanguage,
            !language.isEmpty,
            let oldLanguage = oldPreferredLanguage,
            language != oldLanguage
        else {
            oldPreferredLanguage = preferredlanguage
            return
        }
        oldPreferredLanguage = language
        userSetLanguage = nil
    }
}
