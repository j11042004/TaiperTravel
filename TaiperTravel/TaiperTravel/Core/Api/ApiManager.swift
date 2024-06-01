//
//  ApiManager.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/30.
//

import Foundation
import Alamofire
import Combine

struct ApiManager {
    typealias ApiResultPublisher<T: ApiResponseProtocol> = AnyPublisher<BaseResponse<T>, ApiError>
    
    /// 取得 session 與對應的憑證，session 要確保在打完 request 前活著，否則憑證會驗證失敗，故在此用個全域變數儲存
    ///  後續要驗證憑證在調整
    private let httpSession: Session = Session()
}
extension ApiManager {
    public func requestAttractions(page: Int) -> ApiResultPublisher<AttractionsResponse> {
        let requestData = AttractionsRequest(page: page)
        return sendApi(service: .Attractions, parameters: requestData)
    }
    
    public func requestEventNews(page: Int) -> ApiResultPublisher<EventNewsResponse> {
        let requestData = EventNewsRequest(page: page)
        return sendApi(service: .EventNews, parameters: requestData)
    }
}

extension ApiManager {
    private func sendApi<T: ApiResponseProtocol>(service: ApiService, parameters: ApiReqeustProtocol) -> AnyPublisher<BaseResponse<T>, ApiError> {
        Future { promise in
            let url = URL(string: service.urlPath)!
            let method = service.method
            let headers = parameters.headers()
            let timeOut = service.timeOut
            AF.request(url, method: method, parameters: parameters.jsonDict, headers: headers, requestModifier: { request in
                request.timeoutInterval = timeOut
            })
            .response { dataResponse in
                if let afError = dataResponse.error {
                    let resultError: NSError
                    if let error = afError.underlyingError {
                        resultError = error as NSError
                    }
                    else {
                        resultError = afError as NSError
                    }
                    return promise(.failure(ApiError.connectFail(resultError)))
                }
                
                let httpResponse = dataResponse.response
                let responseCode = httpResponse?.statusCode ?? 0
                if responseCode != 200 {
                    let apiError = ApiError.connect("\(responseCode)", CommonName.ApiErrorMessage.other.rawValue, nil)
                    return promise(.failure(apiError))
                }
                    
                guard let data = dataResponse.data else {
                    return promise(.failure(.resultFail("\(responseCode)", CommonName.DataFail.empty.rawValue, nil)))
                }
                
                do {
                    let result = try JSONDecoder().decode(BaseResponse<T>.self, from: data)
                    return promise(.success(result))
                } catch {
                    return promise(.failure(.resultFail("\(responseCode)", CommonName.DataFail.parse.rawValue, data)))
                }
            }
        }.eraseToAnyPublisher()
    }
}

private extension ApiError {
    static func connectFail(_ error: NSError) -> ApiError {
        var messageType: CommonName.ApiErrorMessage = .other
        switch error.code {
        case NSURLErrorTimedOut:
            messageType = .timedOut
        case NSURLErrorCannotConnectToHost,
             NSURLErrorNotConnectedToInternet:
            messageType = .internetFail
        default: break
        }
        return ApiError.connect("(\(error.code))", messageType.rawValue, error)
    }
}
