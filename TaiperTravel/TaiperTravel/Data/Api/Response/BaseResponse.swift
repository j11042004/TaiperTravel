//
//  BaseResponse.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/1.
//

import Foundation

protocol ApiResponseProtocol: Codable { }

struct BaseResponse<T: ApiResponseProtocol>: Codable {
    let total: Int
    let data: [T]
}

