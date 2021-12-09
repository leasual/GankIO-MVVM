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

class WelfareViewModel: ViewModel {
    var currentPage = 1
    var count = 0
    var dataList = [SectionModel<String, String>]()
    
    func transform(input: Input) -> Output {
        let collectionData = BehaviorRelay<[SectionModel<String, String>]>(value: [])
        let endPullToRefresh = BehaviorRelay<Bool>(value: false)
        let endLoadMore = BehaviorRelay<FooterRefreshState>(value: .normal)
        
        dataList.append(SectionModel(model: "", items: []))
        
        input.pullToRefresh
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
                    self.dataList[0].items = []
                    self.convertCollectionData(model)
                    self.count = self.dataList[0].items.count
                    collectionData.accept(self.dataList)
                    endPullToRefresh.accept(false)
                    break
                case .error(let error):
                    if let type = error as? MoyaError {
                        logError("moya error= \(type)")
                    }
                    logError("error= \(error)")
                    endPullToRefresh.accept(false)
                    break
                default:
                    break
                }
            }).disposed(by: rx.disposeBag)
        
        input.loadMore
            .flatMapLatest({ _ -> Observable<CategoryDataModel> in
                self.currentPage += 1
                return self.apiService.getTechCategoryData(category: "福利", page: self.currentPage)
            })
            .materialize()
            .share()
            .subscribe(onNext: { (event) in
                switch event {
                case .next(let model):
                    if model.data != nil && !model.data!.isEmpty {
                        self.convertCollectionData(model)
                        self.count = self.dataList[0].items.count
                        collectionData.accept(self.dataList)
                        endLoadMore.accept(model.data!.count == 10 ? FooterRefreshState.normal : FooterRefreshState.noMoreData)
                    }else {
                        endLoadMore.accept(FooterRefreshState.noMoreData)
                    }
                    break
                case .error(let error):
                    if let type = error as? MoyaError {
                        logError("welfare moya error= \(type)")
                    }
                    logError("welfare error= \(error)")
                    endLoadMore.accept(FooterRefreshState.normal)
                    break
                default:
                    break
                }
            }).disposed(by: rx.disposeBag)
        
        
        return Output(collectionDataList: collectionData, endPullToRefresh: endPullToRefresh, endLoadMore: endLoadMore)
    }
    
    private func convertCollectionData(_ model: CategoryDataModel) {
        
        guard let data = model.data, !data.isEmpty else {
            return
        }
        let tempData = dataList[0].items + data.map({ (model) -> String in
            return model.url ?? ""
        })
        dataList[0].items = tempData
        logDebug("dataListSize= \(dataList.count)")
    }
}

extension WelfareViewModel: ViewModelType {
    struct Input {
        let pullToRefresh: Observable<Void>
        let loadMore: Observable<Void>
    }
    
    struct Output {
        let collectionDataList: BehaviorRelay<[SectionModel<String, String>]>
        let endPullToRefresh: BehaviorRelay<Bool>
        let endLoadMore: BehaviorRelay<FooterRefreshState>
    }
}
