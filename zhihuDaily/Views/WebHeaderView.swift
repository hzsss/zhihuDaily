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
    var bgImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        sourceLabel.textColor = .white
        sourceLabel.font = UIFont.systemFont(ofSize: 10.0)
        
        bgImageView.contentMode = .scaleAspectFill
        
        addSubview(bgImageView)
        addSubview(titleLabel)
        addSubview(sourceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let sourceLabelSize = sourceLabel.sizeThatFits(bounds.size)
        sourceLabel.frame = CGRect(x: bounds.width - sourceLabelSize.width - 10,
                                   y: bounds.height - sourceLabelSize.height - 5,
                                   width: sourceLabelSize.width,
                                   height: sourceLabelSize.height)
        
        
        let titleLabelHeight = titleLabel.sizeThatFits(bounds.size).height
        titleLabel.frame = CGRect(x: 10, y: sourceLabel.frame.minY - titleLabelHeight - 10, width: bounds.width, height: titleLabelHeight)
        
        bgImageView.frame = bounds
    }
    
    func setupWebHeaderView(imageURL: URL?, title: String?, source: String?) {
        
        bgImageView.kf.setImage(with: imageURL)
        titleLabel.text = title
        if let sourceText = source {
            sourceLabel.text = "图片 \(sourceText)"
        }
        
        setNeedsLayout()
    }
    
}
