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
    private(set) var imageInfos: [AttractionImageInfo]
    
    init(name: String, introduction: String, imageInfos: [AttractionImageInfo]) {
        self.name = name
        self.introduction = introduction
        self.imageInfos = imageInfos
    }
    
    init(_ attractionsResponse: AttractionsResponse, downloadImgSet: Set<AttractionImageInfo>) {
        self.name = attractionsResponse.name
        self.introduction = attractionsResponse.introduction
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
