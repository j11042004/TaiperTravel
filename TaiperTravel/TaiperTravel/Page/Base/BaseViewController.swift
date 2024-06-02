//
//  BaseViewController.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/29.
//

import UIKit

class BaseViewController: UIViewController {
    private lazy var loadingView: LoadingView = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subscribeViewModel()
        self.bindData()
    }
}

extension BaseViewController {
    func showLoading(_ show: Bool) {
        if loadingView.superview == nil {
            view.addSubview(loadingView)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                loadingView.topAnchor.constraint(equalTo: view.topAnchor),
                loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
                loadingView.rightAnchor.constraint(equalTo: view.rightAnchor),
                loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        loadingView.isHidden = !show
    }
    
    @objc func subscribeViewModel() { }
    @objc func bindData() { }
}
