//
//  ApiService.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/30.
//

import Foundation
import Alamofire

private let defaultTimeOut: TimeInterval = 15

enum ApiService {
    case Attractions
    case EventNews
}

extension ApiService {
    public var urlPath: String {
        let languageCode = Constant.shared.langage.apiCode
        switch self {
        case .Attractions:
            return BaseUrl + languageCode + "/Attractions/All"
        case .EventNews:
            return BaseUrl + languageCode + "/Events/News"
        }
    }
    
    public var method: HTTPMethod { return .get }
    
    public var timeOut: TimeInterval { return defaultTimeOut }
}

extension ApiService {
    public func httpRequest<T: ApiReqeustProtocol>(_ requestInfo: T) -> URLRequest {
        let url: URL = URL(string: urlPath)!
        var request = URLRequest(url: url)
        request.method = method
        request.headers = requestInfo.headers()
        return request
    }
}
