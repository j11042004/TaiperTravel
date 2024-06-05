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
    
    private(set) var imageInfos: [ImageRepository.ImageInfo]
    
    init(name: String, introduction: String, openTime: String, tel: String, address: String, webUrl: String, imageInfos: [ImageRepository.ImageInfo]) {
        self.name = name
        self.introduction = introduction
        self.openTime = openTime
        self.tel = tel
        self.address = address
        self.webUrl = webUrl
        self.imageInfos = imageInfos
    }
    
    init(_ attractionsResponse: AttractionsResponse, downloadImgSet: Set<ImageRepository.ImageInfo>) {
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
    public mutating func renewImages(from imageSet: Set<ImageRepository.ImageInfo>) {
        for index in 0..<self.imageInfos.count {
            guard 
                let imageInfo = self.imageInfos[safe: index],
                let newInfo = imageSet.first(where: { $0 == imageInfo }),
                let newImg = newInfo.image,
                newImg.size != .zero
            else { continue }
            
            self.imageInfos[index] = newInfo
        }
    }
}
