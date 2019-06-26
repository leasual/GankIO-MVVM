//
//  WelfareViewModel.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/24.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import RxCocoa
import Moya
import RxDataSources
import RxSwift

class WelfareViewModel: ViewModel, ViewModelType {
    var currentPage = 1
    struct Input {
        let pullToRefresh: Observable<Void>
        let loadMore: Driver<Void>
    }
    
    struct Output {
        let collectionDataList: BehaviorRelay<[SectionModel<String, String>]>
        let endPullToRefresh: BehaviorRelay<Bool>
        let endLoadMore: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let collectionDataDriver = BehaviorRelay<[SectionModel<String, String>]>(value: [])
        let endPullToRefresh = BehaviorRelay<Bool>(value: false)
        let endLoadMore = BehaviorRelay<Bool>(value: false)
        
        input.pullToRefresh
            .asObservable()
            .startWith(())
            .flatMapLatest({ _ -> Observable<CategoryDataModel> in
                self.currentPage = 1
                return self.apiService.getTechCategoryData(category: "福利", page: self.currentPage)
            })
            .materialize()
            .share()
            .subscribe(onNext: { (event) in
                switch event {
                case .next(let model):
                    collectionDataDriver.accept(self.convertCollectionData(model))
                    endPullToRefresh.accept(true)
                    break
                case .error(let error):
                    if let type = error as? MoyaError {
                        logError("moya error= \(type)")
                    }
                    logError("error= \(error)")
                    endPullToRefresh.accept(true)
                    break
                default:
                    break
                }
            }).disposed(by: rx.disposeBag)
        
        input.loadMore
            .asObservable()
            .startWith(())
            .flatMapLatest({ _ -> Observable<CategoryDataModel> in
                self.currentPage += 1
                return self.apiService.getTechCategoryData(category: "福利", page: self.currentPage)
            })
            .materialize()
            .share()
            .subscribe(onNext: { (event) in
                switch event {
                case .next(let model):
                    collectionDataDriver.accept(collectionDataDriver.value + self.convertCollectionData(model))
                    endPullToRefresh.accept(true)
                    break
                case .error(let error):
                    if let type = error as? MoyaError {
                        logError("moya error= \(type)")
                    }
                    logError("error= \(error)")
                    endPullToRefresh.accept(true)
                    break
                default:
                    break
                }
            }).disposed(by: rx.disposeBag)
        
        
        return Output(collectionDataList: collectionDataDriver, endPullToRefresh: endPullToRefresh, endLoadMore: endLoadMore)
    }
    
    private func convertCollectionData(_ model: CategoryDataModel) -> [SectionModel<String, String>] {
        var dataList = [SectionModel<String, String>]()
        
        guard let data = model.data, !data.isEmpty else {
            return dataList
        }
        dataList.append(SectionModel<String, String>(model: "", items: data.map({ (model) -> String in
            return model.url ?? ""
        })))
        logDebug("dataListSize= \(dataList.count)")
        return dataList
    }
}
