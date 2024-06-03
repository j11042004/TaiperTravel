//
//  AttractionDetailViewModel.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/3.
//

import Foundation
import Combine
import UIKit


class AttractionDetailViewModel: BaseViewModel {
    private let attractionInfo: HomeAttraction
    
    @Published var openTime: String = ""
    @Published var address: String = ""
    @Published var tel: String = ""
    @Published var webUrl: String = ""
    @Published var introduction: String = ""
    
    init(attractionInfo: HomeAttraction) {
        self.attractionInfo = attractionInfo
        super.init()
        self.pageTitle = attractionInfo.name
        
        self.openTime = attractionInfo.openTime
        self.address = attractionInfo.address
        self.tel = attractionInfo.tel
        self.webUrl = attractionInfo.webUrl
        self.introduction = attractionInfo.introduction
    }
}

extension AttractionDetailViewModel {
    public func downloadImages() {
        NSLog("downloadImages")
    }
    
    public func callTel() {
        //TODO: 處理區碼
        Tools.openBrowser(url: "tel://\(tel)")
    }
    
    public func showWebPage() {
        guard let url = URL(string: self.webUrl) else { return }
        let webViewModel = WebViewModel(title: pageTitle, url: url)
        
        let webVC = WebViewController(nibName: String(describing: WebViewController.self), bundle: nil)
        webVC.setup(viewModel: webViewModel)
        self.showNextVC.send(webVC)
    }
}
