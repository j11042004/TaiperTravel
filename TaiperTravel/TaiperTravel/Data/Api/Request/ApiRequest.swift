//
//  ApiRequest.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/1.
//

import Foundation
import Alamofire

protocol ApiReqeustProtocol: Encodable { }

extension ApiReqeustProtocol {
    public func headers() -> HTTPHeaders {
        return HeaderInfo().headers()
    }
}

public struct HeaderInfo: Encodable {
    let contentType: String = "application/json; charset=utf-8"
    let accept: String = "application/json"
    
    public func headers() -> HTTPHeaders {
        let headers: [HTTPHeader] = [
            .init(name: CodingKeys.contentType.rawValue, value: contentType),
            .init(name: CodingKeys.accept.rawValue, value: accept),
        ]
        return HTTPHeaders(headers)
    }
    
    enum CodingKeys: String, CodingKey {
        case contentType = "Content-Type"
        case accept = "accept"
    }
}
