//
//  HomeNewsCell.swift
//  zhihuDaily
//
//  Created by weiphone on 2019/3/4.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit
import Kingfisher

class HomeNewsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var story: Story? {
        didSet {
            titleLabel.text = story?.title
            
            let imageURL = URL(string: story?.images.first ?? "")
            coverImageView.kf.setImage(with: imageURL)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}
