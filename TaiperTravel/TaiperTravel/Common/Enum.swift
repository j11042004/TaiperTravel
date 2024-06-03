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

enum Language: String {
    /// 正體中文
    case zhTW = "zh-tw"
    /// 簡體中文
    case zhCN = "zh-cn"
    /// 英文
    case en = "en"
    /// 日文
    case ja = "ja"
    /// 韓文
    case ko = "ko"
    /// 西班牙文
    case es = "es"
    /// 印尼文
    case id = "id"
    /// 泰文
    case th = "th"
    /// 越南文
    case vi = "vi"
}

enum CustomColor: String {
    case grayTextColor = "GrayTextColor"
    case navigationBarColor = "NavigationBarColor"
    case whiteTextColor = "WhiteTextColor"
    case blueTextColor = "BlueTextColor"
    case backgroundColor = "BackgroundColor"
    
    var color: UIColor? { .init(named: self.rawValue) }
}
