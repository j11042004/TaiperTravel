//
//  Enum.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/30.
//

import Foundation
import UIKit

enum ApiError: Error {
    case connect(_ code: String?, _ message: String?, _ error: Error?)
    case resultFail(_ code: String?, _ message: String?, _ data: Data? = nil)
}

enum Language: CaseIterable, CommonNameProtocol {
    /// 正體中文
    case taiwan
    /// 簡體中文
    case china
    /// 英文
    case english
    /// 日文
    case japan
    /// 韓文
    case korean
    /// 西班牙文
    case spanish
    /// 印尼文
    case indonesian
    /// 泰文
    case thai
    /// 越南文
    case vietnamese
    
    var name: String { [Language.className, "\(self)"].joined(separator: ".").localized }
    
    var apiCode: String {
        switch self {
        case .taiwan: return "zh-tw"
        case .china: return "zh-cn"
        case .english: return "en"
        case .japan: return "ja"
        case .korean: return "ko"
        case .spanish: return "es"
        case .indonesian: return "id"
        case .thai: return "th"
        case .vietnamese: return "vi"
        }
    }
    
    var lprojId: String {
        switch self {
        case .taiwan: return "zh-Hant"
        case .china: return "zh-Hans"
        case .english: return "en"
        case .japan: return "ja"
        case .korean: return "ko"
        case .spanish: return "es"
        case .indonesian: return "id"
        case .thai: return "th"
        case .vietnamese: return "vi"
        }
    }
    
    //MARK: - Init
    init(lprojId: String?) {
        self = Language.allCases.first(where: { $0.lprojId == lprojId }) ?? .taiwan
    }
    init(name: String) {
        self = Language.allCases.first(where: { $0.name == name }) ?? .taiwan
    }
}

enum CustomColor: String {
    case grayTextColor = "GrayTextColor"
    case navigationBarColor = "NavigationBarColor"
    case whiteTextColor = "WhiteTextColor"
    case blueTextColor = "BlueTextColor"
    case backgroundColor = "BackgroundColor"
    
    var color: UIColor? { .init(named: self.rawValue) }
}
