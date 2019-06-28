//
//  ReadingArticleViewModel.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/27.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class ReadingArticleViewModel: ViewModel {
    
    var currentPage = 1
    
    func transform(input: Input) -> Output {
        let endPullToRefresh = BehaviorRelay<Bool>(value: false)
        let endLoadMore = BehaviorRelay<FooterRefreshState>(value: .normal)
        let tableDataList = BehaviorRelay<[ReadingArticleSectionType]>(value: [])
        var dataList = [ReadingArticleSectionType]()
        
        input.pullToRefresh
            .startWith(())
            .flatMapLatest({ _ -> Observable<ReadingFeedModel> in
                self.currentPage = 1
                return self.apiService.getReadingCategoryData(category: input.category ?? "", page: self.currentPage)
            })
            .materialize()
            .share()
            .subscribe(onNext: { (event) in
                switch event {
                case .next(let model):
                    dataList = []
                    dataList.append(self.convertTableData(model: model))
                    tableDataList.accept(dataList)
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
            .flatMapLatest({ _ -> Observable<ReadingFeedModel> in
                self.currentPage += 1
                return self.apiService.getReadingCategoryData(category: input.category ?? "", page: self.currentPage)
            })
            .materialize()
            .share()
            .subscribe(onNext: { (event) in
                switch event {
                case .next(let model):
                    if model.data != nil && !model.data!.isEmpty {
                        dataList.append(self.convertTableData(model: model))
                        tableDataList.accept(dataList)
                        endLoadMore.accept(model.data!.count == 10 ? FooterRefreshState.normal : FooterRefreshState.noMoreData)
                    }else {
                        endLoadMore.accept(FooterRefreshState.noMoreData)
                    }
                    break
                case .error(let error):
                    if let type = error as? MoyaError {
                        logError("moya error= \(type)")
                    }
                    logError("error= \(error)")
                    endLoadMore.accept(FooterRefreshState.normal)
                    break
                default:
                    break
                }
            }).disposed(by: rx.disposeBag)
        
        return Output(endPullToRefresh: endPullToRefresh, endLoadMore: endLoadMore, tableDataList: tableDataList)
    }
    
    private func convertTableData(model: ReadingFeedModel) -> ReadingArticleSectionType {

        return ReadingArticleSectionType(header: "", items: model.data?.map({ (model) -> ReadingArticleSectionItem in
            return .SectionItem(model: model)
        }) ?? [])
    }
}

extension ReadingArticleViewModel: ViewModelType {
    
    struct Input {
        let category: String?
        let pullToRefresh: Observable<Void>
        let loadMore: Observable<Void>
    }
    
    struct Output {
        let endPullToRefresh: BehaviorRelay<Bool>
        let endLoadMore: BehaviorRelay<FooterRefreshState>
        let tableDataList: BehaviorRelay<[ReadingArticleSectionType]>
    }
}
