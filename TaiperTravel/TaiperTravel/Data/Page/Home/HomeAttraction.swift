//
//  HomeAttraction.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/2.
//

import Foundation
import UIKit

struct HomeAttraction {
    let name: String
    let introduction: String
    let openTime: String
    let tel: String
    let address: String
    let webUrl: String
    
    private(set) var imageInfos: [AttractionImageInfo]
    
    init(name: String, introduction: String, openTime: String, tel: String, address: String, webUrl: String, imageInfos: [AttractionImageInfo]) {
        self.name = name
        self.introduction = introduction
        self.openTime = openTime
        self.tel = tel
        self.address = address
        self.webUrl = webUrl
        self.imageInfos = imageInfos
    }
    
    init(_ attractionsResponse: AttractionsResponse, downloadImgSet: Set<AttractionImageInfo>) {
        self.name = attractionsResponse.name
        self.introduction = attractionsResponse.introduction
        
        self.openTime = attractionsResponse.open_time
        self.tel = attractionsResponse.tel
        self.address = attractionsResponse.address
        self.webUrl = attractionsResponse.url
        
        self.imageInfos = attractionsResponse.images.compactMap({ imageInfo in
            let img = downloadImgSet.first(where: { $0.url == imageInfo.url })?.image
            return .init(url: imageInfo.url, image: img)
        })
    }
}
extension HomeAttraction {
    public mutating func insert(imageInfos: [AttractionImageInfo]) {
        self.imageInfos = Array(self.imageInfos) + imageInfos
    }
}
