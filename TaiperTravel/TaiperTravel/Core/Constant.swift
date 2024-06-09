//
//  Constant.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/9.
//

import Foundation

class Constant {
    public static let shared = Constant()
    
    public private(set) lazy var langage: Language = {
        return .init()
    }()
}

//MARK: - Public Func
extension Constant {
    public func change(language: Language) {
        self.langage = language
    }
}
