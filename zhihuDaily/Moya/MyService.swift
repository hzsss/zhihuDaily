//
//  MyService.swift
//  zhihuDaily
//
//  Created by weiphone on 2019/3/4.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit
import Moya

enum MyService {
    case getNewsList // 获取热报数据
    case getNewsDetail(userId: Int) // 获取文章详情数据
    case getNewsExtra(userId: Int) // 获取新闻额外信息
}

extension MyService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://news-at.zhihu.com/api")!
    }
    
    var path: String {
        switch self {
        case .getNewsList:
            return "4/news/latest"
        case let .getNewsDetail(userId):
            return "4/news/\(userId)"
        case let .getNewsExtra(userId):
            return "4/story-extra/\(userId)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var task: Task {
        switch self {
        case .getNewsList:
            return .requestPlain
        case .getNewsDetail:
            return .requestPlain
        case .getNewsExtra:
            return .requestPlain
        }
    }
    
}

