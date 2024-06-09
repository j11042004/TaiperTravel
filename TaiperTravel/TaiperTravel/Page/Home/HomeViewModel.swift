//
//  HomeViewModel.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/29.
//

import Foundation
import Combine
import UIKit

class HomeViewModel: BaseViewModel {
    //MARK: Combine
    private(set) var reloadAttractionSubject: PassthroughSubject<Void, Never> = .init()
    private(set) var reloadNewsSubject: PassthroughSubject<Void, Never> = .init()
    
    @Published private(set) var homePageInfos: [HomePageInfo] = [
        .init(type: .attraction, attractions: []),
        .init(type: .news, news: [])
    ] {
        didSet {
            if homePageInfos.count > 2 { homePageInfos = Array(homePageInfos[0..<2]) }
        }
    }
    
    @Published private(set) var showLanguageSelections: [Language] = []
    
    //MARK: Data
    /// 景點 Array
    private var attractionResponses: [AttractionsResponse] = []
    /// 最新消息 Array
    private var latestNewsResponses: [EventNewsResponse] = [] {
        didSet {
            let homeNewsArray: [HomeNews] = latestNewsResponses.compactMap({ .init($0) })
            let newsPageInfo = HomePageInfo(type: .news, news: homeNewsArray)
            if let index = homePageInfos.firstIndex(where: { $0.type == .news }) {
                homePageInfos[index] = newsPageInfo
            }
            else {
                homePageInfos.append(newsPageInfo)
            }
            reloadNewsSubject.send(())
        }
    }
    
    private let apiManager = ApiManager()
    
    private var attractionPageCount = 1
    private var newsPageCount = 1
}

//MAR: - Public Func
extension HomeViewModel {
    public func initData() {
        resetModelDatas()
        
        // 確定全資料 Api 有回來 再關閉 Loading
        Publishers.CombineLatest(reloadAttractionSubject, reloadNewsSubject)
            .delay(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, _) in
                weakSelf.showLoading(false)
            }
            .store(in: &cancellableSet)
    }
    
    //MARK: UI
    public func vcChangeAppearance() {
        let interfaceStyle: UIUserInterfaceStyle
        switch UIApplication.shared.rootWindow?.overrideUserInterfaceStyle {
        case .dark:
            interfaceStyle = .light
        default:
            interfaceStyle = .dark
        }
        UIApplication.shared.rootWindow?.overrideUserInterfaceStyle = interfaceStyle
    }
    public func vcChangeLanguage() {
        showLanguageSelections = Language.allCases
    }
    public func vcSelect(newLanguage: String?) {
        let language = Language(name: newLanguage ?? "")
        if language == Constant.shared.langage { return }
        Constant.shared.change(language: language)
        
        resetModelDatas()
        
        apiLoadAttraction()
        apiLoadEventNews()
    }
    
    public func vcLoadHomePageInfo(_ index: Int) -> HomePageInfo? {
        return homePageInfos[safe: index]
    }
    public func vcLoadAttraction(indexPath: IndexPath) -> HomeAttraction? {
        return homePageInfos[safe: indexPath.section]?.attractions[safe: indexPath.row]
    }
    public func vcLoadNews(indexPath: IndexPath) -> HomeNews? {
        return homePageInfos[safe: indexPath.section]?.news[safe: indexPath.row]
    }
    public func vcLoadMore(type: HomePageInfo.InfoType) {
        switch type {
        case .attraction:
            apiLoadAttraction()
        case .news:
            apiLoadEventNews()
        }
    }
    
    public func vcSelect(indexPath: IndexPath) {
        guard let selectInfo = homePageInfos[safe: indexPath.section] else {
            return
        }
        switch selectInfo.type {
        case .attraction:
            guard let attraction = selectInfo.attractions[safe: indexPath.row] else { return }
            let attractionviewModel = AttractionDetailViewModel(attractionInfo: attraction)
            let attractionDetailVC = AttractionDetailViewController(nibName: String(describing: AttractionDetailViewController.self), bundle: nil)
            attractionDetailVC.setup(viewModel: attractionviewModel)
            self.showNextVC.send(attractionDetailVC)
            
        case .news:
            guard 
                let news = selectInfo.news[safe: indexPath.row],
                let url = URL(string: news.webUrl)
            else { return }
            let title = CommonName.Page.Title.newsWeb.string
            
            let webViewModel = WebViewModel(title: title, url: url)
            
            let webVC = WebViewController(nibName: String(describing: WebViewController.self), bundle: nil)
            webVC.setup(viewModel: webViewModel)
            self.showNextVC.send(webVC)
        }
    }
    
    //MARK: API
    public func apiLoadAttraction() {
        self.showLoading(true)
        apiManager.requestAttractions(page: attractionPageCount)
            .withUnretained(self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished: break
                case .failure(let apiError):
                    self.reloadAttractionSubject.send(())
                    self.processApiAlert(error: apiError, showAlert: true)
                }
            } receiveValue: { (weakSelf, apiResult) in
                weakSelf.loadAttractionImages(apiResult.data)
            }
            .store(in: &cancellableSet)
    }
    
    public func apiLoadEventNews() {
        self.showLoading(true)
        apiManager.requestEventNews(page: newsPageCount)
            .withUnretained(self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished: break
                case .failure(let apiError):
                    self.latestNewsResponses.append(contentsOf: [])
                    self.processApiAlert(error: apiError, showAlert: true)
                }
            } receiveValue: { (weakSelf, apiResult) in
                if weakSelf.newsPageCount == 1 { weakSelf.latestNewsResponses.removeAll() }
                weakSelf.latestNewsResponses.append(contentsOf: apiResult.data)
                weakSelf.newsPageCount += 1
            }
            .store(in: &cancellableSet)
    }
}

extension HomeViewModel {
    private func resetModelDatas() {
        pageTitle = CommonName.Page.Title.home.string
        attractionPageCount = 1
        newsPageCount = 1
    }
    
    private func loadAttractionImages(_ attractions: [AttractionsResponse]) {
        if self.attractionPageCount == 1 { self.attractionResponses.removeAll() }
        self.attractionResponses.append(contentsOf: attractions)
        
        // 下載所有第一張照片
        let willDownloadPublishers = attractionResponses
            .compactMap({ $0.images.first?.url })
            .filter({ url in
                !ImageRepository.shared.imageInfoSet.contains { url == $0.url }
            })
            .compactMap({ apiManager.downloadImage(url: $0) })
        
        /// 等待所有的 Publisher 回應
        Publishers.ZipMany(willDownloadPublishers)
            .receive(on: DispatchQueue.main)
            .compactMap({ infos in
                infos.compactMap { ImageRepository.ImageInfo(url: $0.url, image: $0.img) }
            })
            .withUnretained(self)
            .sink(receiveCompletion: { [weak self] _ in
                guard let self = self else { return }
                let homeAttractions: [HomeAttraction] = attractions.compactMap({ .init($0, downloadImgSet: ImageRepository.shared.imageInfoSet) })
                let attractionPageInfo = HomePageInfo(type: .attraction, attractions: homeAttractions)
                if let index = homePageInfos.firstIndex(where: { $0.type == .attraction }) {
                    homePageInfos[index] = attractionPageInfo
                }
                else {
                    homePageInfos.insert(attractionPageInfo, at: 0)
                }
                
                reloadAttractionSubject.send(())
                
                self.attractionPageCount += 1
                
                
            }, receiveValue: { (weakSelf, imageInfos) in
                imageInfos.forEach {
                    ImageRepository.shared.imageInfoSet.insert($0)
                }
            })
            .store(in: &cancellableSet)
    }
}
