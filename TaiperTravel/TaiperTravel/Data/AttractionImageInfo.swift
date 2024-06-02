//
//  AttractionImageInfo.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/2.
//

import Foundation
import UIKit

struct AttractionImageInfo: Hashable, Identifiable, Equatable {
    var id: String { url.absoluteString }
    
    let url: URL
    let image: UIImage?
    
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
}
