//
//  HomePageInfo.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/2.
//

import Foundation

struct HomePageInfo {
    enum InfoType {
        case attraction
        case news
        var title: String {
            switch self {
            case .attraction: return CommonName.Page.Home.attraction.rawValue
            case .news: return CommonName.Page.Home.news.rawValue
            }
        }
    }
    
    let type: InfoType
    let attractions: [HomeAttraction]
    let news: [HomeNews]
    
    init(type: HomePageInfo.InfoType, attractions: [HomeAttraction] = [], news: [HomeNews] = []) {
        self.type = type
        
        switch type {
        case .attraction:
            self.attractions = attractions
            self.news = []
        case .news:
            self.attractions = []
            self.news = news
        }
    }
}
