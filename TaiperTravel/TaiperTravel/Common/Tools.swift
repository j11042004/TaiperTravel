//
//  Tools.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/30.
//

import Foundation
import UIKit

struct Tools {
//MARK: - Alert
    /// 顯示一個按鈕的 Alert
    /// - Parameters:
    ///   - title: 預設 title 為 "訊息"
    ///   - buttonTitle: 預設 Button Title 為 確定
    public static func alertOneSelWith(title: String = CommonName.AlertInfo.message.string,
                                       message: String,
                                       buttonTitle: String = CommonName.AlertInfo.sure.string,
                                       confirm: (()-> Void)?) -> UIAlertController {
        let alert = alertWith(title: title, message: message, leftTitle: buttonTitle, rightTitle: nil, leftConfirm: confirm)
        return alert
    }
    
    /// 顯示左為「取消」，右為「確定」的 Alert
    /// - Parameters:
    ///   - cancelConfirm: 取消 Call back
    ///   - sureConfirm: 確認 Call back
    public static func alert(title: String = CommonName.AlertInfo.message.string,
                             message: String,
                             cancelConfirm: (()-> Void)? = nil,
                             sureConfirm: (()-> Void)? = nil) -> UIAlertController {
        return alertWith(title: title, message: message, leftConfirm: cancelConfirm, rightConfirm: sureConfirm)
    }
    
    /// 顯示左右選項的 Alert
    /// - Parameters:
    ///   - title: 預設 title 為 "訊息"
    ///   - leftTitle: 預設 左 Button Title 為 "取消"
    ///   - rightTitle: 預設 右 button 為 "確定"
    ///   - leftConfirm: 預設為 nil
    ///   - rightConfirm: 預設為 nil
    public static func alertWith(title: String = CommonName.AlertInfo.message.string,
                                 message: String,
                                 leftTitle: String? = CommonName.AlertInfo.cancel.string,
                                 rightTitle: String? = CommonName.AlertInfo.sure.string,
                                 leftConfirm: (()-> Void)? = nil,
                                 rightConfirm: (()-> Void)? = nil) -> UIAlertController {
        var actions = [UIAlertAction]()
        if let title = leftTitle {
            let leftAction = UIAlertAction(title: title, style: .default) { _ in
                leftConfirm?()
            }
            actions.append(leftAction)
        }
        
        if let title = rightTitle {
            let rightAction = UIAlertAction(title: title, style: .default) { _ in
                rightConfirm?()
            }
            actions.append(rightAction)
        }
        return alertWith(title: title, message: message, actions: actions)
    }
    
    /// 顯示多選項 Alert
    /// - Parameters:
    ///   - title: Title
    ///   - message: Message
    ///   - actions: Alert 選項
    /// - Returns: Alert
    public static func alertWith(title: String,
                                 message: String,
                                 actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        return alert
    }
    
//MARK: - 外開瀏覽器
    public static func openBrowser(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
}
