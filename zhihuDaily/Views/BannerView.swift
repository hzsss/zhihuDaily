//
//  BannerView.swift
//  zhihuDaily
//
//  Created by weiphone on 2019/3/5.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

class BannerDetailView: UIView {
    var titleLabel: UILabel = UILabel()
    var imageView: UIImageView = UIImageView()
    var titleBgView: UIView = UIView()
    
    var topStory: TopStory?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.textColor = .white
        titleBgView.backgroundColor = .black
        titleBgView.alpha = 0.7
        imageView.contentMode = .scaleAspectFill
        
        addSubview(imageView)
        addSubview(titleBgView)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        
        // 标题高度
        let titleLabelHeight = titleLabel.sizeThatFits(bounds.size).height
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(self)
        }
        
        // 标题背景
        titleBgView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self)
            make.height.equalTo(titleLabelHeight + 20)
        }
    }
    
    func update(with topStory: TopStory) {
        // 设置标题
        titleLabel.text = topStory.title
        
        // 设置图片
        let imageURL = URL(string: topStory.imageURL)
        imageView.kf.setImage(with: imageURL)
        imageView.kf.indicatorType = .activity
        
        self.topStory = topStory
        
        setNeedsLayout()
    }
}

class BannerView: UIView, UIScrollViewDelegate {
    var topStories: [TopStory] = []
    var bannerDetailViews: [BannerDetailView] = []
    var scrollView: UIScrollView = UIScrollView()
    
    var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    var timer: Timer!
    var pageControl: UIPageControl = UIPageControl()
    
    var tapBannerDetailView: ((_ topStory: TopStory?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        scrollView.delegate = self
        
        addSubview(scrollView)
        addSubview(pageControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(center)
            make.bottom.equalTo(0)
            make.height.equalTo(20)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(0)
            make.width.equalTo(self)
            make.height.equalTo(bounds.height - 20)
        }
    }
    
    func configScrollView() { // 后续需要优化，太冗余
        let width = scrollView.bounds.width
        let height = scrollView.bounds.height
        
        scrollView.contentSize = CGSize(width: width * 3, height: height)
        // 显示中间的视图
        scrollView.contentOffset = CGPoint(x: width, y: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        var i: Int = 0
        while i < 3 {
            let bannerDetailView = BannerDetailView()
            bannerDetailViews.append(bannerDetailView)
            scrollView.addSubview(bannerDetailView)
            
            i += 1
        }
        
        for (i, bannerDetailView) in bannerDetailViews.enumerated() {
            bannerDetailView.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: height)
            
            let index = (currentPage - 1 + i + topStories.count) % topStories.count
            
            bannerDetailView.update(with: self.topStories[index])
        }
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapBanner))
        let centerBannerDetailView: BannerDetailView = bannerDetailViews[1]
        centerBannerDetailView.addGestureRecognizer(tapGesture)
        
        // 添加定时器
        timer = Timer.init(timeInterval: 3.0, repeats: true, block: { [weak self] (timer) in
            guard let sself = self else { return }
            sself.scrollView.setContentOffset(CGPoint(x: width * 2, y: 0), animated: true)
        })
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func showBanner(with topStories: [TopStory]) {
        // 刷新数据时清除定时器(这个时机有问题)
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        pageControl.numberOfPages = topStories.count
        
        self.topStories = topStories
        
        configScrollView()
    }
    
    // scrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 暂停定时器
        timer.fireDate = Date.distantFuture
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 两秒后启动定时器
        timer.fireDate = Date(timeInterval: 2.0, since: Date())
    }
    
    // 定时器滑动时调用
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        resetContent(scrollView)
    }
    
    // 手动滑动时调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetContent(scrollView)
    }
    
    func resetContent(_ scrollView: UIScrollView) {
        // 滑动的距离
        let scrollDistance = scrollView.contentOffset.x - scrollView.bounds.width
        
        // 设置当前页
        if scrollDistance > 0 { // 下一页
            currentPage = (currentPage + 1 + topStories.count) % topStories.count
        } else if scrollDistance < 0 { // 上一页
            currentPage = (currentPage - 1 + topStories.count) % topStories.count
        }
        
        // 重置偏移量
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: false)
        
        for (i, bannerDetailView) in bannerDetailViews.enumerated() {
            let index = (currentPage - 1 + i + topStories.count) % topStories.count
            
            bannerDetailView.update(with: self.topStories[index])
        }
    }
    
    @objc func tapBanner() {
        if tapBannerDetailView != nil {
            let centerBannerDetailView: BannerDetailView = bannerDetailViews[1]
            tapBannerDetailView?(centerBannerDetailView.topStory)
        }
    }
}
