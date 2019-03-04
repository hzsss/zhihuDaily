//
//  HZSHomeViewController.swift
//  zhihuDaily
//
//  Created by weiphone on 2019/3/4.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit

class HZSHomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib.init(nibName: "HomeNewsCell", bundle: nil), forCellReuseIdentifier: "HZSHomeNewsCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HZSHomeNewsCell", for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bannerModel = BannerModel()
        bannerModel.getBannerList()
    }
}
