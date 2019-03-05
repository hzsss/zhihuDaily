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

// 列表数据
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

// 文章详情
struct NewsDetail: Codable {
    var title: String?
    var body: String?
    var image: String?
    var image_source: String?
    var ga_prefix: String?
    var id: Int?
    var type: Int?
    var css: [String]?
}


// 获取轮播图数据
class NewsModel: NSObject {
    
    let provider = MoyaProvider<MyService>()
    
    // 获取列表数据
    func getNewsData(completion: @escaping ([TopStory], [Story]) -> Void) {
        provider.request(.getNewsList) { (result) in
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
    
    // 获取文章详情
    func getNewsDetailData(userId: Int, completion: @escaping (NewsDetail) -> Void) {
        provider.request(.getNewsDetail(userId: userId)) { (result) in
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    let newsDetailData = try decoder.decode(NewsDetail.self, from: response.data)
                    completion(newsDetailData)
                } catch {
                    print("网络异常")
                }
            case let .failure(error):
                print("文章数据获取错误\(error)")
            }
        }
    }
}
