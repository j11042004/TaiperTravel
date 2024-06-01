//
//  EventNewsRequest.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/2.
//

import Foundation

struct EventNewsRequest: ApiReqeustProtocol {
    let page: Int
    
    enum CodingKeys: String, CodingKey {
        case page
    }
    
    init(page: Int) {
        self.page = page
    }
}
