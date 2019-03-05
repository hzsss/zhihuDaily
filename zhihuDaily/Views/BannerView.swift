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
        
        titleLabel.textColor = .white
        
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.frame = bounds
        
        // 标题高度
        let titleLabelHeight = titleLabel.sizeThatFits(bounds.size).height
        titleLabel.frame = CGRect(x: 10, y: bounds.height - titleLabelHeight, width: bounds.width, height: titleLabelHeight)
    }
    
    func update(with topStory: TopStory) {
        // 设置标题
        titleLabel.text = topStory.title
        
        // 设置图片
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
    
    var leftBannerDetailView: BannerDetailView = BannerDetailView()
    var centerBannerDetailView: BannerDetailView = BannerDetailView()
    var rightBannerDetailView: BannerDetailView = BannerDetailView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
    
    func configScrollView() { // 后续需要优化，太冗余
        let width = scrollView.bounds.width
        let height = scrollView.bounds.height
        
        scrollView.contentSize = CGSize(width: width * 3, height: height)
        scrollView.isPagingEnabled = true
        
        scrollView.addSubview(leftBannerDetailView)
        scrollView.addSubview(centerBannerDetailView)
        scrollView.addSubview(rightBannerDetailView)
        
        leftBannerDetailView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        centerBannerDetailView.frame = CGRect(x: width, y: 0, width: width, height: height)
        rightBannerDetailView.frame = CGRect(x: width * 2, y: 0, width: width, height: height)
        
        // 初始化视图
        leftBannerDetailView.update(with: self.topStories![0])
        centerBannerDetailView.update(with: self.topStories![1])
        rightBannerDetailView.update(with: self.topStories![2])
        
        // 添加定时器
        timer = Timer.init(timeInterval: 3.0, repeats: true, block: { [weak self] (timer) in
            guard let sself = self else { return }
            sself.currentPage = (sself.currentPage + 1) % 3
            sself.scrollView.setContentOffset(CGPoint(x: width * CGFloat(sself.currentPage), y: 0), animated: true)
        })
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func showBanner(with topStories: [TopStory]) {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        
        self.topStories = topStories
        
        configScrollView()
    }
}
