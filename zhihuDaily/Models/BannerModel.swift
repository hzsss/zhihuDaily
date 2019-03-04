//
//  BannerModel.swift
//  zhihuDaily
//
//  Created by weiphone on 2019/3/4.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit
import Moya

struct BannerData: Codable {
    var newsId: Int
    var url: String
    var thumbnail: String
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case newsId = "news_id"
        case url
        case thumbnail
        case title
    }
}

struct BannerResult: Codable {
    var recent: [BannerData]
}

// 获取轮播图数据
class BannerModel: NSObject {
    var bannerList: [BannerData] = []
    
    let provider = MoyaProvider<MyService>()
    
    func getBannerList() {
        provider.request(.getBannerList) { (result) in
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    let bannerResult = try decoder.decode(BannerResult.self, from: response.data)
                    self.bannerList = bannerResult.recent
                } catch {
                    print("网络异常!")
                }
            case let .failure(error): 
                print("轮播数据获取错误\(error)")
            }
        }
    }
}
