//
//  String+Extension.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/6.
//

import Foundation
extension String {
    var localized: String { NSLocalizedString(self, comment: self) }
    
    func localized(language: String) -> String {
        guard
            let path = Bundle.main.path(forResource: language, ofType: "lproj"),
            let bundleName = Bundle(path: path)
        else {
            return self
        }
        return NSLocalizedString(self, bundle: bundleName, comment: self)
    }
}
