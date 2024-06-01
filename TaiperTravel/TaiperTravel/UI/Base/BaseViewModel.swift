//
//  BaseViewModel.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/29.
//

import Foundation
import Combine

class BaseViewModel: NSObject {
    @Published private(set) var showLoading: Bool = false
    @Published private(set) var showApiErrorAlert: PassthroughSubject<String?, Never> = .init()
}

extension BaseViewModel {
    public func processApiAlert(error: ApiError, showAlert: Bool) {
        if !showAlert {
            showApiErrorAlert.send(nil)
            return
        }
        
        var errorCode: String? = ""
        var errorMessage: String? = ""
        
        switch error {
        case .connect(let code, let message, let error):
            errorCode = code
            errorMessage = message
            if let error = error {
                let nsError = error as NSError
                errorMessage = "\(nsError.domain)(\(code ?? ""))\n\(message ?? "")"
            }
            break
        case .resultFail(let code, let message, _):
            errorCode = code
            var codeInfo = ""
            if let errCode = errorCode ,
               errCode.count > 0 {
                codeInfo = "[\(errCode)]："
            }
            errorMessage = codeInfo + "\(message ?? "")"
            break
        }
        
        let alertMessage = errorMessage ?? ""
        showApiErrorAlert.send(alertMessage)
    }
}
