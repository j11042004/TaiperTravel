//
//  CommonImage.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/6.
//

import Foundation
import UIKit
struct CommonImage { }

extension CommonImage {
    enum UserInterface: String {
        case showDark = "light.min"
        case showLight = "light.max"
        
        var image: UIImage? {
            UIImage(systemName: self.rawValue)
        }
    }
}

