//
//  LoadingView.swift
//  CombineTest
//
//  Created by 周佳緯 on 2024/5/30.
//

import UIKit

class LoadingView: UIView {
    private weak var contentView : UIView!
    @IBOutlet private weak var loadingContentView: UIView!
    convenience init(){
        self.init(frame: CGRect.zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customerInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customerInit()
    }
    
    private func customerInit() {
        let xibStr = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: xibStr, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        contentView = view
        self.addSubview(contentView)
        
        loadingContentView.cornerRadius()
    }
}
