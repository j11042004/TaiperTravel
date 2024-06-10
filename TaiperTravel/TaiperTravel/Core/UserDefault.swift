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
        get {
            guard
                let savedData = UserDefaults.standard.value(forKey: key.rawValue) as? Data,
                let resultData = AES256().decrypt(data: savedData)
            else {
                return nil
            }
            
            if T.self is String.Type {
                return String(data: resultData, encoding: .utf8) as? T
            }
            else if T.self is Bool.Type {
                let boolStr = String(data: resultData, encoding: .utf8)
                return NSString(string: boolStr ?? "\(false)").boolValue as? T
            }
            else {
                return try? JSONDecoder().decode(T.self, from: resultData)
            }
        }
        
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: key.rawValue)
                return
            }
            
            var data: Data?
            if let str = newValue as? String {
                data = str.data(using: .utf8)
            }
            else if let bool = newValue as? Bool {
                data = "\(bool)".data(using: .utf8)
            }
            else {
                data = try? JSONEncoder().encode(newValue)
            }
            
            guard
                let data = data,
                let encryptData = AES256().encrypt(data: data)
            else { return }
            UserDefaults.standard.setValue(encryptData, forKey: key.rawValue)
        }
    }
}
