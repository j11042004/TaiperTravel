//
//  NewsTableCell.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/2.
//

import UIKit

class NewsTableCell: UITableViewCell {
    
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        infoView.cornerRadius(radii: 10)
        infoView.addBorder(width: 5, color: CustomColor.navigationBarColor.color)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setup(title: String, message: String) {
        self.titleLabel.text = title
        self.messageLabel.text = message
    }
}
