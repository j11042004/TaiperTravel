//
//  ImageRepository.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/5.
//

import Foundation
import UIKit

class ImageRepository {
    static let shared = ImageRepository()
    var imageInfoSet: Set<ImageInfo> = .init()
    
    struct ImageInfo: Hashable, Identifiable, Equatable {
        var id: String { url.absoluteString }
        
        let url: URL
        let image: UIImage?
        
        static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    }
}
