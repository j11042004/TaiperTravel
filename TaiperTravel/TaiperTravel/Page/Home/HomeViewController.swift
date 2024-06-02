//
//  HomeViewController.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/29.
//

import UIKit
import Combine

class HomeViewController: BaseViewController {
    private var viewModel: HomeViewModel!
    /// combine 回收 Set
    private var cancellableSet = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        guard let _ = viewModel else  { fatalError("\(#file)'s ViewModel is empty") }
        super.viewDidLoad()
        self.loadTravelData()
    }
}

//MARK: - override Func
extension HomeViewController {
    override func setupUI() {
        super.setupUI()
    }
    
    override func subscribeViewModel() {
        self.viewModel.$showLoading
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, show) in
                weakSelf.showLoading(show)
            }
            .store(in: &cancellableSet)
        
        self.viewModel.showApiErrorAlert
            .compactMap({ $0 })
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, message) in
                weakSelf.viewModel.showLoading(false)
                let alert = Tools.alertOneSelWith(message: message) { }
                self.navigationController?.pushViewController(alert, animated: true)
            }
            .store(in: &cancellableSet)
        
        viewModel.reloadAttractionSubject
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, _) in
                NSLog("reloadAttractionSubject")
            }
            .store(in: &cancellableSet)
        viewModel.reloadNewsSubject
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, _) in
                NSLog("reloadNewsSubject")
            }
            .store(in: &cancellableSet)
    }
    
    override func bindData() {
        viewModel.initData()
    }
}

//MARK: - Public Func
extension HomeViewController {
    public func setup(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
}

//MARK: - Private Func
extension HomeViewController {
    private func loadTravelData() {
        self.viewModel.loadAttraction()
        self.viewModel.loadEventNews()
    }
}
