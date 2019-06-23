//
//  APIService.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/21.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import Moya_ObjectMapper
import ObjectMapper
import RxSwift
import RxSwiftExt
import Moya

protocol API {
    func getTodayData() -> Observable<OneDayModel>
    func getHistoryDate() -> Observable<Any>
    func getTechCategoryData(category: String, page: Int) -> Observable<CommonFeedModel>
    func getOneDay(year: String, month: String, day: String) -> Observable<OneDayModel>
    func getReadingCategories() -> Observable<ReadingCatetoryModel>
    func getReadingSubCategories(category: String) -> Observable<ReadingSubCategoryModel>
    func getReadingCategoryData(category: String, page: Int) -> Observable<ReadingFeedModel>
}

class APIService: API {
    let gankIOAPIProvider: CustomGankIOProvider<GankIOAPI>
    
    init(gankIOAPIProvider: CustomGankIOProvider<GankIOAPI>) {
        self.gankIOAPIProvider = gankIOAPIProvider
    }
    
    func getTodayData() -> Observable<OneDayModel> {
        return requestObject(.today, type: OneDayModel.self)
    }
    
    func getHistoryDate() -> Observable<Any> {
        return request(.historyDate)
    }
    
    func getTechCategoryData(category: String, page: Int) -> Observable<CommonFeedModel> {
        return requestObject(.techCategoryData(category: category, page: page), type: CommonFeedModel.self)
    }
    
    func getOneDay(year: String, month: String, day: String) -> Observable<OneDayModel> {
        return requestObject(.getOneDay(year: year, month: month, day: day), type: OneDayModel.self)
    }
    
    func getReadingCategories() -> Observable<ReadingCatetoryModel> {
        return requestObject(.readingCategories, type: ReadingCatetoryModel.self)

    }
    
    func getReadingSubCategories(category: String) -> Observable<ReadingSubCategoryModel> {
        return requestObject(.readingSubCategories(category: category), type: ReadingSubCategoryModel.self)
    }
    
    func getReadingCategoryData(category: String, page: Int) -> Observable<ReadingFeedModel> {
        return requestObject(.readingCategoryData(category: category, page: page), type: ReadingFeedModel.self)
    }

}

extension APIService {
    
    private func request (_ target: GankIOAPI) -> Observable<Any> {
        return gankIOAPIProvider.request(target)
        .mapJSON()
        .observeOn(MainScheduler.instance)
        .asObservable()
    }
    
    private func requestWithoutMapping(_ target: GankIOAPI) -> Observable<Moya.Response> {
        return gankIOAPIProvider.request(target)
            .observeOn(MainScheduler.instance)
            .asObservable()
    }
    
    private func requestObject<T: BaseMappable>(_ target: GankIOAPI, type: T.Type) -> Observable<T> {
        return gankIOAPIProvider.request(target)
            .mapObject(T.self)
            .observeOn(MainScheduler.instance)
            .asObservable()
    }
    
    private func requestArray<T: BaseMappable>(_ target: GankIOAPI, type: T.Type) -> Observable<[T]> {
        return gankIOAPIProvider.request(target)
            .mapArray(T.self)
            .observeOn(MainScheduler.instance)
            .asObservable()
    }
}
