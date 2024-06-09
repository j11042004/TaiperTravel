//
//  HomeViewController.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/5/29.
//

import UIKit
import Combine

class HomeViewController: BaseViewController {
    @IBOutlet private weak var tableView: UITableView!
    private lazy var changeInterfaceStyleItemBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(CommonImage.UserInterface.showDark.image, for: .normal)
        return btn
    }()
    private lazy var changeLanguageItemBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(CommonImage.ChangeLanguage.global.image, for: .normal)
        return btn
    }()
    
    private var viewModel: HomeViewModel!
    
    private let headerName = String(describing: HomeInfoTableHeader.self)
    private let attractionCellName = String(describing: AttractionTableCell.self)
    private let newsCellName = String(describing: NewsTableCell.self)
    
    override func viewDidLoad() {
        guard let _ = viewModel else  { fatalError("\(#file)'s ViewModel is empty") }
        super.viewDidLoad()
    }
}

//MARK: - override Func
extension HomeViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        resetUserInterfaceStyle()
    }
    
    override func setupUI() {
        super.setupUI()
        setupTableView()
        setupBarItem()
        resetUserInterfaceStyle()
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
        
        self.viewModel.showErrorAlert
            .compactMap({ $0 })
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, message) in
                weakSelf.viewModel.showLoading(false)
                let alert = Tools.alertOneSelWith(message: message) { }
                weakSelf.present(alert, animated: true)
            }
            .store(in: &cancellableSet)
        
        self.viewModel.$showLanguageSelections
            .filter({ !$0.isEmpty })
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink(receiveValue: { (weakSelf, languages) in
                var actions = languages.compactMap({
                    UIAlertAction(title: "\($0.name)", style: .default) { [weak self] action in
                        guard let self = self else { return }
                        self.viewModel.vcSelect(newLanguage: action.title ?? "")
                    }
                })
                
                let cancel = UIAlertAction(title: CommonName.AlertInfo.cancel.string, style: .cancel)
                actions.append(cancel)
                
                let title = CommonName.AlertInfo.message.string
                let message = CommonName.AlertMessage.selectLanguage.string
                let alert = Tools.alertWith(title: title,
                                            message: message,
                                            actions: actions)
                weakSelf.present(alert, animated: true)
            })
            .store(in: &cancellableSet)
        
        Publishers.Zip(viewModel.reloadAttractionSubject, viewModel.reloadNewsSubject)
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, _) in
                weakSelf.tableView.reloadData()
            }
            .store(in: &cancellableSet)
    }
    
    override func bindData() {
        viewModel.initData()
        
        if #available(iOS 17.0, *) {
            // iOS 17 監聽是否更換 Light/Dark mode
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
                self.resetUserInterfaceStyle()
            }
        }
        
        changeLanguageItemBtn.publisher(for: .touchUpInside)
            .withUnretained(self)
            .sink { (weakSelf, _) in
                weakSelf.viewModel.vcChangeLanguage()
            }
            .store(in: &cancellableSet)
        
        changeInterfaceStyleItemBtn.publisher(for: .touchUpInside)
            .withUnretained(self)
            .sink { (weakSelf, _) in
                weakSelf.viewModel.vcChangeAppearance()
            }
            .store(in: &cancellableSet)
    }
    //MARK: - IBAction
}

//MARK: - Public Func
extension HomeViewController {
    public func setup(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
}

//MARK: - Private Func
extension HomeViewController {
    
    //MARK: UI
    private func setupTableView() {
        if #available(iOS 15.0, *) { tableView.sectionHeaderTopPadding = 0 }
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(.init(nibName: headerName, bundle: nil), forHeaderFooterViewReuseIdentifier: headerName)
        tableView.register(.init(nibName: attractionCellName, bundle: nil), forCellReuseIdentifier: attractionCellName)
        tableView.register(.init(nibName: newsCellName, bundle: nil), forCellReuseIdentifier: newsCellName)
    }
    private func setupBarItem() {
        self.navigationItem.rightBarButtonItems = [changeLanguageItemBtn, changeInterfaceStyleItemBtn].compactMap({ UIBarButtonItem(customView: $0) })
    }
    
    private func resetUserInterfaceStyle() {
        tableView.reloadData()
        
        let interfaceStyleImgName: CommonImage.UserInterface = self.traitCollection.userInterfaceStyle == .dark ? .showLight : .showDark
        changeInterfaceStyleItemBtn.setImage(interfaceStyleImgName.image, for: .normal)
    }
}

//MARK: - TableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.vcSelect(indexPath: indexPath)
    }
}

//MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.homePageInfos.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pageInfo = viewModel.vcLoadHomePageInfo(section) else { return 0 }
        switch pageInfo.type {
        case .attraction: return pageInfo.attractions.count
        case .news: return pageInfo.news.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pageType = viewModel.vcLoadHomePageInfo(indexPath.section)?.type else { return UITableViewCell() }
        switch pageType {
        case .attraction: do {
            let attractionTableCell = tableView.dequeueReusableCell(withIdentifier: attractionCellName, for: indexPath) as! AttractionTableCell
            let attraction = viewModel.vcLoadAttraction(indexPath: indexPath)
            let image = attraction?.imageInfos.first?.image
            attractionTableCell.setup(title: attraction?.name ?? "", message: attraction?.introduction ?? "", image: image)
            return attractionTableCell
        }
        case .news: do {
            let newsTableCell = tableView.dequeueReusableCell(withIdentifier: newsCellName, for: indexPath) as! NewsTableCell
            let news = viewModel.vcLoadNews(indexPath: indexPath)
            newsTableCell.setup(title: news?.title ?? "", message: news?.message ?? "")
            return newsTableCell
        }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let pageInfo = viewModel.vcLoadHomePageInfo(section) else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerName) as! HomeInfoTableHeader
        header.setup(title: pageInfo.type.title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
