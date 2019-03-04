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
    case getBannerList // 获取轮播数据
    case getNewsList // 获取热报数据
}

extension MyService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://news-at.zhihu.com/api")!
    }
    
    var path: String {
        switch self {
        case .getBannerList:
            return "3/news/hot"
        case .getNewsList:
            return "4/news/latest"
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
        case .getBannerList:
            return .requestPlain
        case .getNewsList:
            return .requestPlain
        }
    }
    
}

