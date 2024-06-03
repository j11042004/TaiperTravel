//
//  AttractionDetailViewController.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/3.
//

import UIKit
import Combine

class AttractionDetailViewController: BaseViewController {
    private var viewModel: AttractionDetailViewModel!
    //MARK: UI
    @IBOutlet private weak var openTimeLabel: UILabel!
    
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var addressBtn: UIButton!
    
    @IBOutlet private weak var telLabel: UILabel!
    @IBOutlet private weak var telBtn: UIButton!
    
    @IBOutlet private weak var webUrlLabel: UILabel!
    @IBOutlet private weak var webUrlBtn: UIButton!
    
    @IBOutlet private weak var introductionLabel: UILabel!
    
    @IBOutlet var contentViews: [UIView]!
    
    //MARK: - Override Func
    override func viewDidLoad() {
        guard let _ = viewModel else  { fatalError("\(#file)'s ViewModel is empty") }
        super.viewDidLoad()
    }


}

//MARK: - override Func
extension AttractionDetailViewController {
    override func setupUI() {
        super.setupUI()
        contentViews.forEach {
            $0.cornerRadius()
            $0.addBorder(width: 5, color: CustomColor.navigationBarColor.color)
        }
    }
    
    override func subscribeViewModel() {
        self.viewModel.$pageTitle
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 as String? })
            .assign(to: \.title, on: self)
            .store(in: &cancellableSet)
        
        self.viewModel.showNextVC
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, vc) in
                weakSelf.navigationController?.pushViewController(vc, animated: true)
            }
            .store(in: &cancellableSet)
        
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
                weakSelf.navigationController?.pushViewController(alert, animated: true)
            }
            .store(in: &cancellableSet)
        
        //MARK: CusomUI
        self.viewModel.$openTime
            .compactMap({ $0 as String? })
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: openTimeLabel)
            .store(in: &cancellableSet)
        self.viewModel.$address
            .compactMap({ $0 as String? })
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: addressLabel)
            .store(in: &cancellableSet)
        self.viewModel.$tel
            .compactMap({ $0 as String? })
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: telLabel)
            .store(in: &cancellableSet)
        self.viewModel.$webUrl
            .compactMap({ $0 as String? })
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: webUrlLabel)
            .store(in: &cancellableSet)
        self.viewModel.$introduction
            .compactMap({ $0 as String? })
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: introductionLabel)
            .store(in: &cancellableSet)
    }
    
    override func bindData() {
        self.addressBtn.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, _) in
                
            }.store(in: &cancellableSet)
        
        self.telBtn.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, _) in
                weakSelf.viewModel.callTel()
            }.store(in: &cancellableSet)
        
        self.webUrlBtn.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, _) in
                weakSelf.viewModel.showWebPage()
            }.store(in: &cancellableSet)
        
        self.viewModel.downloadImages()
    }
}

//MARK: - Public Func
extension AttractionDetailViewController {
    public func setup(viewModel: AttractionDetailViewModel) {
        self.viewModel = viewModel
    }
}
