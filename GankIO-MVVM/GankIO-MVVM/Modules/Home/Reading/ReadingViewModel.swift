//
//  ReadingViewModel.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/27.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxCocoa

class ReadingViewModel: ViewModel {
    
    func transform(input: Input) -> Output {
        let categoryData = BehaviorRelay<[ReadingSectionType]>(value: [])
        var categoryList = [ReadingSectionType]()
        apiService.getReadingCategories()
            .startWith()
            .flatMapLatest { model -> Observable<[ReadingSubCategoryModel]> in
                guard let data = model.data, !data.isEmpty else {
                    return Observable.empty()
                }
                
                let observerList = data.map { (model) -> Observable<ReadingSubCategoryModel> in
                    return self.apiService.getReadingSubCategories(category: model.nameEN ?? "")
                }
                return Observable.combineLatest(observerList)
            }
            .materialize()
            .share()
            .subscribe(onNext: { (event) in
                switch event {
                case .next(let model):
                    logDebug("model count\(model.count)")
                    if !model.isEmpty {
                        for data in model {
                            if data.data != nil {
                                categoryList.append(ReadingSectionType(header: "", items: data.data!.map({ (model) -> ReadingSectionItem in
                                    return .SectionItem(model: model)
                                })))
                            }
                        }
                        categoryData.accept(categoryList)
                    }else {
                        categoryData.accept([])
                    }
                    break
                case .error(let error):
                    if let type = error as? MoyaError {
                        logError("moya error= \(type)")
                    }
                    logError("error= \(error)")
                    break
                default:
                    break
                }
            }).disposed(by: rx.disposeBag)
        
        return Output(categoryData: categoryData)
    }
}

extension ReadingViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        let categoryData: BehaviorRelay<[ReadingSectionType]>
    }
    
}
