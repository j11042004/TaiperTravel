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
        super.viewDidLoad()
        guard let _ = viewModel else  {
            fatalError("\(#file)'s ViewModel is empty")
        }
        
        self.subscribeViewModel()
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
    public func subscribeViewModel() {
        self.viewModel.$showLoading
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, show) in
                weakSelf.showLoading(show)
            }
            .store(in: &cancellableSet)
    }
}
