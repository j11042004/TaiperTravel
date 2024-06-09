//
//  UserDefaultManager.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/9.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: UserDefaultKey
    var wrappedValue: T? {
        get { UserDefaults.standard.value(forKey: key.rawValue) as? T }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key.rawValue)
        }
    }
}
