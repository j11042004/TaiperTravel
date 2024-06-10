//
//  AES256.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/10.
//

import Foundation
import CryptoSwift

struct AES256 {
    private let iv: [UInt8] = Data().bytes
    @Keychain(key: .deviceUUID) private var deviceUUID: String?
    @Keychain(key: .aesKey) private var aesKey: String?
    
    private var key: [UInt8] { (aesKey ?? "").bytes }
    
    init() {
        guard 
            let aesKey = self.aesKey,
            !aesKey.isEmpty
        else {
            self.createAESKey()
            return
        }
    }
}
//MARK: - Public Func
extension AES256 {
    public func encrypt(data: Data) -> Data? {
        let dataBytes = data.bytes
        do {
            let aes = try AES(key: key, blockMode: ECB(), padding: .pkcs7)
            let encrypted = try aes.encrypt(dataBytes)
            let encryptedData = Data(encrypted)
            return encryptedData
        } catch {
            return nil
        }
    }
    
    public func decrypt(data: Data) -> Data? {
        let dataBytes = data.bytes
        do {
            let aesDesc = try AES(key: key, blockMode: ECB(), padding: .pkcs7)
            let decrypt = try dataBytes.decrypt(cipher: aesDesc)
            let decryptData = Data(decrypt)
            return decryptData
        } catch {
            return nil
        }
    }
}

//MARK: - Private Func
extension AES256 {
    /// 產生一把 AES KEY
    private mutating func createAESKey() {
        let uuid = String(deviceUUID?.replacingOccurrences(of: "-", with: "").prefix(10) ?? "")
        // uuid 做sha256
        let str64 = uuid.sha256()
        // 擷取32位
        let dbAESKey = NSString(string: str64).substring(with: NSMakeRange(0,32))
        self.aesKey = dbAESKey
    }
}
