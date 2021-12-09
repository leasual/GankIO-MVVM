//
//  ApiService.swift
//  MvvmArchitecture-Swift
//
//  Created by James on 2019/6/19.
//  Copyright © 2019 geekdroid. All rights reserved.
//

import Foundation
import Moya
import RxSwift

let GankIOProvider = CustomGankIOProvider<GankIOAPI>()

class CustomGankIOProvider<Target> where Target: Moya.TargetType {
    fileprivate let provider: MoyaProvider<Target>
    
    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
         manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
         plugins: [PluginType] = [NetworkLoggerPlugin(verbose: true)],
         trackInflights: Bool = false) {
        self.provider = MoyaProvider(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }
    
    func request(_ token: Target) -> Observable<Moya.Response> {
        return provider.rx.request(token).asObservable()
    }
}

public enum GankIOAPI {
    case today
    case historyDate
    case techCategoryData(category: String, page: Int)
    case getOneDay(year: String, month: String, day: String)
    case readingCategories
    case readingSubCategories(category: String)
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
        case .readingSubCategories(let category):
            return "/xiandu/category/\(category)"
        case .readingCategoryData(let category, let page):
            return "/xiandu/data/id/\(category)/count/10/page/\(page)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .today, .historyDate, .getOneDay, .techCategoryData, .readingCategories, .readingSubCategories, .readingCategoryData:
            return .get
        }
    }
    
    public var sampleData: Data {
        return "{}".utf8EncodedData
    }
    
    public var task: Task {
        switch self {
        case .today, .historyDate, .getOneDay(_, _, _), .techCategoryData(_, _), .readingCategories, .readingSubCategories(_), .readingCategoryData(_, _):
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}

private extension String {
    var utf8EncodedData: Data {
        return self.data(using: .utf8)!
    }
}




