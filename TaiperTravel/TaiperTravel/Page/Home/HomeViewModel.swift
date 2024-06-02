//
//  HomeViewModel.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/29.
//

import Foundation
import Combine

class HomeViewModel: BaseViewModel {
    //MARK: UI
    private(set) var reloadAttractionSubject: PassthroughSubject<Void, Never> = .init()
    private(set) var reloadNewsSubject: PassthroughSubject<Void, Never> = .init()
    
    //MARK: Data
    /// 景點 Array
    @Published private(set) var attractions: [AttractionsResponse] = [] {
        didSet {
            reloadAttractionSubject.send(())
        }
    }
    /// 最新消息 Array
    @Published private(set) var news: [EventNewsResponse] = [] {
        didSet {
            reloadNewsSubject.send(())
        }
    }
    
    /// combine 回收 Set
    private var cancellableSet = Set<AnyCancellable>()
    
    private let apiManager = ApiManager()
    
    private var attractionPageCount = 1
    private var newsPageCount = 1
}

//MAR: - Public Func
extension HomeViewModel {
    public func initData() {
        // 確定全資料 Api 有回來 再關閉 Loading
        Publishers.CombineLatest(reloadAttractionSubject, reloadNewsSubject)
            .delay(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, _) in
                weakSelf.showLoading(false)
            }
            .store(in: &cancellableSet)
    }
    
    public func loadAttraction() {
        self.showLoading(true)
        apiManager.requestAttractions(page: attractionPageCount)
            .withUnretained(self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished: break
                case .failure(let apiError):
                    self.attractions = []
                    self.processApiAlert(error: apiError, showAlert: true)
                }
            } receiveValue: { (weakSelf, apiResult) in
                weakSelf.attractions = apiResult.data
            }
            .store(in: &cancellableSet)
    }
    
    public func loadEventNews() {
        self.showLoading(true)
        apiManager.requestEventNews(page: newsPageCount)
            .withUnretained(self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished: break
                case .failure(let apiError):
                    self.news = []
                    self.processApiAlert(error: apiError, showAlert: true)
                }
            } receiveValue: { (weakSelf, apiResult) in
                weakSelf.news = apiResult.data
            }
            .store(in: &cancellableSet)
    }
}
