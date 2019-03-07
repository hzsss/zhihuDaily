//
//  WebHeaderView.swift
//  zhihuDaily
//
//  Created by weiphone on 2019/3/6.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit
import SnapKit

class WebHeaderView: UIView {
    
    var titleLabel: UILabel = UILabel()
    var sourceLabel: UILabel = UILabel()
    var shadowView: UIView = UIView()
    var bgImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        sourceLabel.textColor = .white
        sourceLabel.font = UIFont.systemFont(ofSize: 10.0)
        
        shadowView.backgroundColor = .black
        shadowView.alpha = 0.2
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.layer.masksToBounds = true
        
        addSubview(bgImageView)
        addSubview(shadowView)
        addSubview(titleLabel)
        addSubview(sourceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        sourceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.bottom.equalTo(-5)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-(sourceLabel.bounds.height + 10))
            make.width.equalTo(bounds.width - 20)
        }
        
        bgImageView.frame = bounds
        shadowView.frame = bounds
    }
    
    func setupWebHeaderView(imageURL: URL?, title: String?, source: String?) {
        
        bgImageView.kf.setImage(with: imageURL)
        bgImageView.kf.indicatorType = .activity
        
        titleLabel.text = title
        if let sourceText = source {
            sourceLabel.text = "图片: \(sourceText)"
        }
        
        setNeedsLayout()
    }
    
}
