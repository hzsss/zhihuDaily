//
//  HZSHomeViewController.swift
//  zhihuDaily
//
//  Created by weiphone on 2019/3/4.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import MJRefresh

class HZSHomeViewController: UITableViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    var stories: [Story] = [] // 日报列表
    var topStories: [TopStory] = [] // 轮播列表
    var bannerView: BannerView? // 轮播视图
    var newsModel: NewsModel = NewsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "知乎日报"

        self.tableView.register(UINib.init(nibName: "HomeNewsCell", bundle: nil), forCellReuseIdentifier: "HZSHomeNewsCell")
        
        // 设置缺省页
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.newsModel.getNewsData { [weak self] (topStories, stories) in
                guard let sself = self else { return }
                sself.topStories = topStories
                sself.stories = stories
                DispatchQueue.main.async {
                    sself.tableView.reloadData()
                    sself.bannerView?.showBanner(with: topStories)
                }
                sself.tableView.mj_header.endRefreshing()
            }
        })
        
        tableView.mj_header.beginRefreshing()
        
        // 轮播器
        bannerView = BannerView()
        bannerView?.tapBannerDetailView = { [weak self] (topStory) in
            guard let topStory = topStory, let sself = self else { return }
            let detailVc = HZSDetailViewController()
            sself.newsModel.getNewsDetailData(userId: topStory.storyID) { (newsDetailData) in
                detailVc.newsDetail = newsDetailData
            }
            sself.newsModel.getNewsExtraData(userId: topStory.storyID, completion: { (newsExtraData) in
                detailVc.newsExtra = newsExtraData
            })
            sself.navigationController?.pushViewController(detailVc, animated: true)
        }
        tableView.tableHeaderView = bannerView
        
        let footerView: HomeFooterView = Bundle.main.loadNibNamed("HomeFooterView", owner: self, options: nil)?.first as! HomeFooterView
        tableView.tableFooterView = footerView
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 250)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HZSHomeNewsCell", for: indexPath) as! HomeNewsCell
        cell.story = stories[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVc = HZSDetailViewController()
        newsModel.getNewsDetailData(userId: stories[indexPath.row].storyID) { (newsDetailData) in
            detailVc.newsDetail = newsDetailData
        }
        newsModel.getNewsExtraData(userId: stories[indexPath.row].storyID, completion: { (newsExtraData) in
            detailVc.newsExtra = newsExtraData
        })
        navigationController?.pushViewController(detailVc, animated: true)
    }
    
    // 设置缺省页
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text: String = "暂无数据"
        return NSAttributedString(string: text)
    }
}
