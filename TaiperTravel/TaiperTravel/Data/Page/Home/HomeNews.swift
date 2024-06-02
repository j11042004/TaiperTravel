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
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    init(_ newsResponse: EventNewsResponse) {
        self.title = newsResponse.title
        self.message = newsResponse.description
    }
}
