//
//  AttractionDetailImageCollectCell.swift
//  TaiperTravel
//
//  Created by 周佳緯 on 2024/6/5.
//

import UIKit

class AttractionDetailImageCollectCell: UICollectionViewCell {

    @IBOutlet private weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setup(image: UIImage?) {
        self.imgView.image = image
    }
}
