//
//  BannerView.swift
//  zhihuDaily
//
//  Created by weiphone on 2019/3/5.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit
import Kingfisher

class BannerDetailView: UIView {
    var titleLabel: UILabel = UILabel()
    var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addSubview(titleLabel)
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.frame = bounds
        
        let titleLabelHeight = titleLabel.sizeThatFits(bounds.size).height
        titleLabel.frame = CGRect(x: 0, y: bounds.height - titleLabelHeight, width: bounds.width, height: titleLabelHeight)
    }
    
    func update(with topStory: TopStory) {
        titleLabel.text = topStory.title
        
        let imageURL = URL(string: topStory.imageURL)
        imageView.kf.setImage(with: imageURL)
        
        setNeedsLayout()
    }
}

class BannerView: UIView {
    var topStories: [TopStory]?
    var currentPage: Int = 0 // 当前页
    var timer: Timer?
    var scrollView: UIScrollView = UIScrollView()
    var testBannerDetailView: BannerDetailView = BannerDetailView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
        testBannerDetailView.frame = scrollView.bounds
    }
    
    func showBanner(with topStories: [TopStory]) {
        self.topStories = topStories
        
        scrollView.addSubview(testBannerDetailView)
        testBannerDetailView.update(with: topStories.first!)
    }
}
