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
    
    @Published var openTimeTitle: String = ""
    @Published var openTime: String = ""
    
    @Published var addressTitle: String = ""
    @Published var address: String = ""
    
    @Published var telTitle: String = ""
    @Published var tel: String = ""
    
    @Published var webUrlTitle: String = ""
    @Published var webUrl: String = ""
    
    @Published var introduction: String = ""
    @Published var images: [UIImage] = .init()
    
    private let apiManager = ApiManager()
    
    init(attractionInfo: HomeAttraction) {
        self.attractionInfo = attractionInfo
        super.init()
        self.pageTitle = attractionInfo.name
        
        CommonName.Page.AttractionDetail.allCases.forEach {
            switch $0 {
            case .openTime: self.openTimeTitle = "\($0.string): "
            case .address: self.addressTitle = "\($0.string): "
            case .tel: self.telTitle = "\($0.string): "
            case .website: self.webUrlTitle = "\($0.string): "
            }
        }
        
        
        self.openTime = attractionInfo.openTime
        self.address = attractionInfo.address
        self.tel = attractionInfo.tel
        self.webUrl = attractionInfo.webUrl
        self.introduction = attractionInfo.introduction
        
        if let firstImg = attractionInfo.imageInfos.first?.image {
            self.images = [firstImg]
        }
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
#if targetEnvironment(simulator)
        showErrorAlert.send(CommonName.SimulatorMessage.callTel.string)
#else
        Tools.openBrowser(url: "tel://\(tel)")
#endif
    }
    
    public func showWebPage() {
        guard let url = URL(string: self.webUrl) else { return }
        let webViewModel = WebViewModel(title: pageTitle, url: url)
        
        let webVC = WebViewController(nibName: String(describing: WebViewController.self), bundle: nil)
        webVC.setup(viewModel: webViewModel)
        self.showNextVC.send(webVC)
    }
}
