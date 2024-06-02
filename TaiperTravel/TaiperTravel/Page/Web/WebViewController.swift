//
//  WebViewController.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/2.
//

import UIKit
import WebKit

class WebViewController: BaseViewController {
    @IBOutlet weak var webView: WKWebView!
    
    private var viewModel: WebViewModel!
    override func viewDidLoad() {
        guard let _ = viewModel else  { fatalError("\(#file)'s ViewModel is empty") }
        viewModel.clearWebCache()
        super.viewDidLoad()
    }
}

//MARK: - override Func
extension WebViewController {
    override func setupUI() {
        super.setupUI()
        self.title = self.viewModel.pageTitle
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
        
        viewModel.$urlRequest
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (weakSelf, request) in
                weakSelf.webView.load(request)
            }
            .store(in: &cancellableSet)
    }
    
    override func bindData() {
        webView.navigationDelegate = self
    }
}

//MARK: - Public Func
extension WebViewController {
    public func setup(viewModel: WebViewModel) {
        self.viewModel = viewModel
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let enable = viewModel.webUrlCheckEnable(navigationAction.request.url?.absoluteString)
        decisionHandler(enable ? .allow : .cancel)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        //TODO: 憑證驗證
        completionHandler(.performDefaultHandling, nil)
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation?) {
        self.viewModel.showLoading(true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {
        self.viewModel.showLoading(false)
        
        // 禁止放大缩小
        let injectionJSString = """
            var script = document.createElement('meta');
            script.name = 'viewport';
            script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";
            document.getElementsByTagName('head')[0].appendChild(script);
        """
        webView.evaluateJavaScript(injectionJSString)
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation?, withError error: Error) {
        self.viewModel.showLoading(false)
        
    }
}
