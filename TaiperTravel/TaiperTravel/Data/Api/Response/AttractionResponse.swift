//
//  AttractionResponse.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/1.
//

import Foundation

/// 遊憩景點 Response
struct AttractionsResponse: ApiResponseProtocol {
    let id: Int
    let name: String
    let name_zh: String?
    let open_status: Int
    let introduction: String
    let open_time: String
    let zipcode: String
    let distric: String
    let address: String
    let tel: String
    let fax: String
    let email: String
    let months: String
    let nlat: CGFloat
    let elong: CGFloat
    let official_site: String
    let facebook: String
    let ticket: String
    let remind: String
    let staytime: String
    let modified: String
    let url: String
    
    let category: [AttractionsResponse.Category]
    let target: [Target]
    let service: [Service]
    /// 友善資訊
    let friendly: [Friendly]
    let images: [ImageInfo]
    let files: [File]
    let links: [LinkInfo]
    
    
}

extension AttractionsResponse {
    struct Category: Codable {
        let `id`: Int
        let name: String
    }
    
    struct Target: Codable {
        let `id`: Int
        let name: String
    }
    
    struct Service: Codable {
        let `id`: Int
        let name: String
    }
    
    struct Friendly: Codable {
        let `id`: Int
        let name: String
    }
    
    struct ImageInfo: Codable {
        let src: String
        let subject: String
        let ext: String
    }
    
    struct File: Codable {
        let src: String
        let subject: String
        let ext: String
    }
    
    struct LinkInfo: Codable {
        let src: String
        let subject: String
    }
}
