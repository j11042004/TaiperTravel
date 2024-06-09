//
//  Constant.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/9.
//

import Foundation

class Constant {
    public static let shared = Constant()
    
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
