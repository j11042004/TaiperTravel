//
//  CommonName.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/30.
//

import Foundation
import UIKit

protocol CommonNameProtocol { }
extension CommonNameProtocol {
    static var strucName: String { String(describing: Self.self) }
}

struct CommonName {
    enum AlertInfo: CommonNameProtocol {
        /// 完成
        case complete
        /// 訊息
        case message
        /// 確定
        case sure
        /// 取消
        case cancel
        /// 確認
        case confirm
        
        var string: String {
            let localKey = [AlertInfo.strucName, "\(self)"].joined(separator: ".")
            return localKey.localized
        }
    }
}

extension CommonName {
    enum ApiErrorMessage: CommonNameProtocol {
        /// 無法連接伺服器。
        case other
        /// 連線逾時。
        case timedOut
        /// 網路連線失敗。
        case internetFail
        /// 無效網址。
        case invalidUrl
        
        var string: String {
            let localKey = [ApiErrorMessage.strucName, "\(self)"].joined(separator: ".")
            return localKey.localized
        }
    }
    enum DataFail: CommonNameProtocol {
        /// 無回傳資料。
        case empty
        /// 資料解析失敗。
        case parse
        
        var string: String {
            let localKey = [DataFail.strucName, "\(self)"].joined(separator: ".")
            return localKey.localized
        }
    }
    enum SimulatorMessage: CommonNameProtocol {
        /// 模擬器不支援打電話。
        case callTel
        
        var string: String {
            let localKey = [SimulatorMessage.strucName, "\(self)"].joined(separator: ".")
            return localKey.localized
        }
    }
}

//MARK: - Page
extension CommonName {
    struct Page: CommonNameProtocol {
        enum Title: CommonNameProtocol {
            /// 悠遊台北
            case home
            /// 最新消息
            case newsWeb
            
            var string: String {
                let localKey = [Page.strucName, Page.Title.strucName, "\(self)"].joined(separator: ".")
                return localKey.localized
            }
        }
        
        enum Home: CommonNameProtocol {
            /// 遊憩景點
            case attraction
            /// 最新消息
            case latestNews
            
            var string: String {
                let localKey = [Page.strucName,Page.Home.strucName, "\(self)"].joined(separator: ".")
                return localKey.localized
            }
        }
    }
}
