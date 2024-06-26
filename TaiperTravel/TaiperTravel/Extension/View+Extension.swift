//
//  View+Extension.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/2.
//

import Foundation
import UIKit

extension UIApplication {
    var rootWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }
    }
}

extension UIView {
    /// 切圓角
    public func cornerRadius(radii: CGFloat = 20) {
        layer.cornerRadius = radii
        layer.masksToBounds = true
    }
    
    public func addBorder(width: CGFloat = 1, color: UIColor?) {
        self.layer.borderColor = color?.cgColor
        self.layer.borderWidth = width
    }
}
