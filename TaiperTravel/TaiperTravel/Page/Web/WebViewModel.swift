//
//  WebViewModel.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/2.
//

import Foundation
import Combine
import UIKit
import WebKit

class WebViewModel: BaseViewModel {
    public private(set) var pageTitle: String = ""
    
    @Published private(set) var urlRequest: URLRequest
    
    init(title: String, url: URL) {
        self.pageTitle = title
        self.urlRequest = URLRequest(url: url)
    }
}

//MAR: - Public Func
extension WebViewModel {
    public func clearWebCache() {
        // 清除 web cache
        let dateFrom = Date(timeIntervalSince1970: 0)
        let storeTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        WKWebsiteDataStore.default().removeData(ofTypes: storeTypes, modifiedSince: dateFrom) { }
    }
    
    public func webUrlCheckEnable(_ checkUrl: String?) -> Bool {
        guard let checkUrl = checkUrl else {
            return true
        }
        guard
            checkUrl.hasPrefix("http://") || checkUrl.hasPrefix("https://"),
            checkUrl != urlRequest.url?.absoluteString
        else {
            return true
        }
        // 若與 request url 不同 外開
        Tools.openBrowser(url: checkUrl)
        return false
    }
}
