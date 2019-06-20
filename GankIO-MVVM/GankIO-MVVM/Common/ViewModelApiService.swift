//
//  ViewModel.swift
//  MvvmArchitecture-Swift
//
//  Created by James on 2019/6/19.
//  Copyright © 2019 geekdroid. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx //it must import this that can found out disposeBag
import ObjectMapper

class ViewModelApiService: NSObject {
    //let apiService: ApiService
    var page = 1
    let error = ErrorTracker()
    
//    let parsedError = PublishSubject<ApiError>()
//    
//    //    let loading = ActivityIndicator()
//    init(apiService: ApiService) {
//        self.apiService = apiService
//        super.init()
//        
//        error.asObservable().map { (error) -> ApiError? in
//            do {
//                let errorResponse = error as? MoyaError
//                if let body = try errorResponse?.response?.mapJSON() as? [String: Any],
//                    let errorResponse = Mapper<ErrorResponse>().map(JSON: body) {
//                    return ApiError.serverError(response: errorResponse)
//                }
//            } catch {
//                print(error)
//            }
//            return nil
//            }.filterNil().bind(to: parsedError).disposed(by: rx.disposeBag)
//        
//        error.asDriver().drive(onNext: { (error) in
//            logError("\(error)")
//        }).disposed(by: rx.disposeBag)
//    }
    
    deinit {
        logDebug("\(type(of: self)): Deinited")
        logResourcesCount()
    }
}
