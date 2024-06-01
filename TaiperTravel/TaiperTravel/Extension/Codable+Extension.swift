//
//  Codable+Extension.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/1.
//

import Foundation

extension Encodable {
    public var jsonDict: [String: Any]? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String : Any]
            return json
        } catch  {
            return nil
        }
    }
}
