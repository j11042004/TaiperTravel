//
//  ApiService.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/30.
//

import Foundation
import Alamofire

enum ApiService {
    case Attractions
    case EventNews
}

extension ApiService {
    public var language: String {
        return Language.zhTW.rawValue
    }
    public var urlPath: String {
        switch self {
        case .Attractions:
            return BaseUrl + language + "/Attractions/All"
        case .EventNews:
            return BaseUrl + language + "/Events/News"
        }
    }
    
    public var method: HTTPMethod { return .get }
}
