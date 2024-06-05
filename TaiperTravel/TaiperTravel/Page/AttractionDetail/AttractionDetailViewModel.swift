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
    private var attractionInfo: HomeAttraction
    
    @Published var openTime: String = ""
    @Published var address: String = ""
    @Published var tel: String = ""
    @Published var webUrl: String = ""
    @Published var introduction: String = ""
    @Published var images: [UIImage] = .init()
    
    private let apiManager = ApiManager()
    
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
    public func loadImage(indexPath: IndexPath) -> UIImage? { self.images[safe: indexPath.item] }
    
    public func downloadImages() {
        self.showLoading(true)
        let willDownloadPublishers = attractionInfo.imageInfos.filter({ imageInfo in
            !ImageRepository.shared.imageInfoSet.contains { imageInfo.url == $0.url }
        })
        .compactMap({ $0.url })
        .compactMap({ apiManager.downloadImage(url: $0) })
        
        // 等待所有的 Publisher 回應
        Publishers.ZipMany(willDownloadPublishers)
            .receive(on: DispatchQueue.main)
            .compactMap({ infos in
                infos.compactMap { ImageRepository.ImageInfo(url: $0.url, image: $0.img) }
            })
            .withUnretained(self)
            .sink(receiveCompletion: { [weak self] _ in
                guard let self = self else { return }
                attractionInfo.renewImages(from: ImageRepository.shared.imageInfoSet)
                self.images = attractionInfo.imageInfos.compactMap({ $0.image })
                
                self.showLoading(false)
            }, receiveValue: { (weakSelf, imageInfos) in
                imageInfos.forEach {
                    ImageRepository.shared.imageInfoSet.insert($0)
                }
            })
            .store(in: &cancellableSet)
        
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
