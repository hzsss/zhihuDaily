//
//  BannerModel.swift
//  zhihuDaily
//
//  Created by weiphone on 2019/3/4.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit
import Moya

// 最新消息
struct NewsData: Codable {
    var date: String
    var stories: [Story]
    var topStories: [TopStory]
    
    enum CodingKeys: String, CodingKey {
        case date
        case stories
        case topStories = "top_stories"
    }
}

// 轮播数据
struct TopStory: Codable {
    var title: String
    var imageURL: String
    var gaPrefix: String
    var type: Int
    var storyID: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case imageURL = "image"
        case gaPrefix = "ga_prefix"
        case type
        case storyID = "id"
    }
}

struct Story: Codable {
    var title: String
    var images: [String]
    var gaPrefix: String
    var type: Int
    var storyID: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case images
        case gaPrefix = "ga_prefix"
        case type
        case storyID = "id"
    }
}


// 获取轮播图数据
class NewsModel: NSObject {
    
    let provider = MoyaProvider<MyService>()
    
    func getNewsData(completion: @escaping ([TopStory], [Story]) -> Void) {
        provider.request(.getBannerList) { (result) in
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    let newsData = try decoder.decode(NewsData.self, from: response.data)
                    completion(newsData.topStories, newsData.stories)
                } catch {
                    print("网络异常!")
                }
            case let .failure(error): 
                print("轮播数据获取错误\(error)")
            }
        }
    }
}
