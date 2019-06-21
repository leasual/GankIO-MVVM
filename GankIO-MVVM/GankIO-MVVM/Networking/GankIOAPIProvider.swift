//
//  ApiService.swift
//  MvvmArchitecture-Swift
//
//  Created by James on 2019/6/19.
//  Copyright © 2019 geekdroid. All rights reserved.
//

import Foundation
import Moya

let GankIOProvider = MoyaProvider<GankIOAPI>()

public enum GankIOAPI {
    case today
    case historyDate
    case techCategoryData(category: String, page: Int)
    case getOneDay(year: String, month: String, day: String)
    case readingCategories
    case readingCategoryData(category: String, page: Int)
}

extension GankIOAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: "http://gank.io/api")!
    }
    
    public var path: String {
        switch self {
        case .today:
            return "/today"
        case .historyDate:
            return "/day/history"
        case .getOneDay(let year, let month, let day):
            return "/history/content/day/\(year)/\(month)/\(day)"
        case .techCategoryData(let category, let page):
            return "/data/\(category)/10/\(page)"
        case .readingCategories:
            return "/xiandu/categories"
        case .readingCategoryData(let category, let page):
            return "/xiandu/data/id/\(category)/count/10/page/\(page)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .today, .historyDate, .getOneDay, .techCategoryData, .readingCategories, .readingCategoryData:
            return .get
        }
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .today, .historyDate, .getOneDay(_, _, _), .techCategoryData(_, _), .readingCategories, .readingCategoryData(_, _):
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}




