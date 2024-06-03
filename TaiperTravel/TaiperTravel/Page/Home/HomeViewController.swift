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
    
    private var viewModel: HomeViewModel!
    
    private let headerName = String(describing: HomeInfoTableHeader.self)
    private let attractionCellName = String(describing: AttractionTableCell.self)
    private let newsCellName = String(describing: NewsTableCell.self)
    
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
        setupTableView()
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
        
        Publishers.CombineLatest(viewModel.reloadAttractionSubject, viewModel.reloadNewsSubject)
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, _) in
                weakSelf.tableView.reloadData()
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
        self.viewModel.apiLoadAttraction()
        self.viewModel.apiLoadEventNews()
    }
    
    //MARK: UI
    private func setupTableView() {
        if #available(iOS 15.0, *) { tableView.sectionHeaderTopPadding = 0 }
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(.init(nibName: headerName, bundle: nil), forHeaderFooterViewReuseIdentifier: headerName)
        tableView.register(.init(nibName: attractionCellName, bundle: nil), forCellReuseIdentifier: attractionCellName)
        tableView.register(.init(nibName: newsCellName, bundle: nil), forCellReuseIdentifier: newsCellName)
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
