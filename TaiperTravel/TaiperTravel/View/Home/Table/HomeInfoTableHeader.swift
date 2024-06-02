//
//  HomeInfoTableHeader.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/2.
//

import UIKit

class HomeInfoTableHeader: UITableViewHeaderFooterView {
    @IBOutlet private weak var titleLabel: UILabel!
    
    public func setup(title: String) {
        self.titleLabel.text = " \(title) "
        let radii = self.titleLabel.bounds.height / 4
        self.titleLabel.cornerRadius(radii: radii)
    }
}
