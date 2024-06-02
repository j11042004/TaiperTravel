//
//  HomeNews.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/2.
//

import Foundation

struct HomeNews {
    let title: String
    let message: String
    let webUrl: String
    
    init(title: String, message: String, webUrl: String) {
        self.title = title
        self.message = message
        self.webUrl = webUrl
    }
    
    init(_ newsResponse: EventNewsResponse) {
        self.title = newsResponse.title
        self.message = newsResponse.description
        self.webUrl = newsResponse.url
    }
}
