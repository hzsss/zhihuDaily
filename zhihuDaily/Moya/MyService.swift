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
        }
    }
    
}

