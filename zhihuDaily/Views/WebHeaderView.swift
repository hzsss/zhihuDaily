//
//  WebHeaderView.swift
//  zhihuDaily
//
//  Created by weiphone on 2019/3/6.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit
import SnapKit

class WebHeaderView: UIImageView {
    
    var titleLabel: UILabel = UILabel()
    var sourceLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(sourceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(100)
        }
        
        sourceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(20)
            make.bottom.equalTo(20)
        }
    }
    
    func setupWebHeaderView(imageURL: URL?, title: String?, source: String?) {
        
        self.kf.setImage(with: imageURL)
        titleLabel.text = title
        sourceLabel.text = source
        
        setNeedsLayout()
    }
    
}
