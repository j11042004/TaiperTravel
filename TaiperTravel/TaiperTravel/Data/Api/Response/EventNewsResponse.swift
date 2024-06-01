//
//  EventNewsResponse.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/2.
//

import Foundation

/// 最新消息 Response
struct EventNewsResponse: ApiResponseProtocol {
    let id: Int
    let title: String
    let description: String
    let begin: String?
    let end: String?
    let posted: String
    let modified: String
    let url: String
    
    let files: [File]
    let links: [LinkInfo]
}

extension EventNewsResponse {
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
