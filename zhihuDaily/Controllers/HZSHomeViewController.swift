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

    var stories: [Story] = []
    var topStories: [TopStory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib.init(nibName: "HomeNewsCell", bundle: nil), forCellReuseIdentifier: "HZSHomeNewsCell")
        
        // 设置缺省页
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        
        // 刷新
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            let newsModel = NewsModel()
            newsModel.getNewsData { [weak self] (topstories, stories) in
                guard let sself = self else { return }
                sself.topStories = topstories
                sself.stories = stories
                DispatchQueue.main.async {
                    sself.tableView.reloadData()
                }
                sself.tableView.mj_header.endRefreshing()
            }
        })
        
        tableView.mj_header.beginRefreshing()
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
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text: String = "暂无数据"
        return NSAttributedString(string: text)
    }
}
