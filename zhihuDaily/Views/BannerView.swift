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

class BannerView: UIView, UIScrollViewDelegate {
    var topStories: [TopStory]?
    var currentPage: Int = 0 // 当前页
    var timer: Timer?
    var scrollView: UIScrollView = UIScrollView()
    
    var leftBannerDetailView: BannerDetailView = BannerDetailView()
    var centerBannerDetailView: BannerDetailView = BannerDetailView()
    var rightBannerDetailView: BannerDetailView = BannerDetailView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.delegate = self
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
        // 显示中间的视图
        scrollView.contentOffset = CGPoint(x: width, y: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.addSubview(leftBannerDetailView)
        scrollView.addSubview(centerBannerDetailView)
        scrollView.addSubview(rightBannerDetailView)
        
        leftBannerDetailView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        centerBannerDetailView.frame = CGRect(x: width, y: 0, width: width, height: height)
        rightBannerDetailView.frame = CGRect(x: width * 2, y: 0, width: width, height: height)
        
        // 初始化视图
        let leftIndex = (currentPage - 1 + topStories!.count) % topStories!.count
        let centerIndex = (currentPage + topStories!.count) % topStories!.count
        let rightIndex = (currentPage + 1 + topStories!.count) % topStories!.count
        
        leftBannerDetailView.update(with: self.topStories![leftIndex])
        centerBannerDetailView.update(with: self.topStories![centerIndex])
        rightBannerDetailView.update(with: self.topStories![rightIndex])
        
        // 添加定时器
        timer = Timer.init(timeInterval: 3.0, repeats: true, block: { [weak self] (timer) in
            guard let sself = self else { return }
            sself.scrollView.setContentOffset(CGPoint(x: width * 2, y: 0), animated: true)
        })
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func showBanner(with topStories: [TopStory]) {
        // 刷新数据时清除定时器(这个时机有问题)
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        
        self.topStories = topStories
        
        configScrollView()
    }
    
    // scrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 暂停定时器
        timer?.fireDate = Date.distantFuture
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 两秒后启动定时器
        timer?.fireDate = Date(timeInterval: 2.0, since: Date())
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
            currentPage = (currentPage + 1 + topStories!.count) % topStories!.count
        } else if scrollDistance < 0 { // 上一页
            currentPage = (currentPage - 1 + topStories!.count) % topStories!.count
        }
        
        // 重置偏移量
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: false)
        
        // 更新图片数据
        let leftIndex = (currentPage - 1 + topStories!.count) % topStories!.count
        let centerIndex = currentPage
        let rightIndex = (currentPage + 1 + topStories!.count) % topStories!.count
        
        leftBannerDetailView.update(with: topStories![leftIndex])
        centerBannerDetailView.update(with: topStories![centerIndex])
        rightBannerDetailView.update(with: topStories![rightIndex])
    }
}
