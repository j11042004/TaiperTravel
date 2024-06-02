//
//  CommonName.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/30.
//

import Foundation
import UIKit
struct CommonName {
    enum AlertInfo: String {
        case complete = "完成"
        case message = "訊息"
        case sure = "確定"
        case cancel = "取消"
        case confirm = "確認"
        
        var string: String {
            return self.rawValue
        }
    }
}

extension CommonName {
    enum ApiErrorMessage: String {
        case other = "無法連接伺服器。"
        case timedOut = "連線逾時。"
        case internetFail = "網路連線失敗。"
        case invalidUrl = "無效網址。"
        
        var string: String {
            return self.rawValue
        }
    }
    enum DataFail: String {
        case empty = "無回傳資料。"
        case parse = "資料解析失敗。"
        
        var string: String {
            return self.rawValue
        }
    }
}

//MARK: - Page
extension CommonName {
    struct Page {
        enum Title: String {
            case home = "悠遊台北"
            
            var string: String {
                return self.rawValue
            }
        }
        
        enum Home: String {
            case attraction = "遊憩景點"
            case news = "最新消息"
            
            var string: String {
                return self.rawValue
            }
        }
    }
    
}
