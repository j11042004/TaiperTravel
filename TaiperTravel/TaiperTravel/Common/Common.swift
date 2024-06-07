//
//  Common.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/30.
//

import Foundation

var isProductVer: Bool {
    #if PRODUCTION_VERSION
    return true
    #else
    return false
    #endif
}

public var BaseUrl: String {
    var url: String
    if isProductVer {
        url = "https://www.travel.taipei/open-api/"
    }
    else {
        url = "https://www.travel.taipei/open-api/"
    }
    return url
}

public var localLanguage: String {
    let nowLocalCode = Bundle.main.preferredLocalizations.first
    return Language(lprojId: nowLocalCode).apiCode
}
