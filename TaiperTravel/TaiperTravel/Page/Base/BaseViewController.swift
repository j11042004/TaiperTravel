//
//  BaseViewController.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/29.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    private lazy var loadingView: LoadingView = .init()
    
    /// combine 回收 Set
    public var cancellableSet = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.subscribeViewModel()
        self.bindData()
    }
}

extension BaseViewController {
    func showLoading(_ show: Bool) {
        if loadingView.superview == nil {
            var showView: UIView = self.view
            if let naviView = self.navigationController?.view {
                showView = naviView
            }
            showView.addSubview(loadingView)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                loadingView.topAnchor.constraint(equalTo: showView.topAnchor),
                loadingView.leftAnchor.constraint(equalTo: showView.leftAnchor),
                loadingView.rightAnchor.constraint(equalTo: showView.rightAnchor),
                loadingView.bottomAnchor.constraint(equalTo: showView.bottomAnchor)
            ])
        }
        
        loadingView.isHidden = !show
    }
    
    @objc func setupUI() {
        setupNavigationUI()
        
        func setupNavigationUI() {
            guard let naviBar = self.navigationController?.navigationBar else { return }
            let textColor = CustomColor.whiteTextColor.color ?? .white
            let barColor = CustomColor.navigationBarColor.color
            
            naviBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
            naviBar.backgroundColor = barColor
            naviBar.barTintColor = textColor
            naviBar.tintColor = textColor
            naviBar.isTranslucent = false
            
            if #available(iOS 15.0, *) {
                let barAppearance = UINavigationBarAppearance()
                barAppearance.backgroundColor = barColor
                barAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
                
                naviBar.scrollEdgeAppearance = barAppearance
                naviBar.standardAppearance = barAppearance
            }
        }
    }
    @objc func subscribeViewModel() { }
    @objc func bindData() { }
}
