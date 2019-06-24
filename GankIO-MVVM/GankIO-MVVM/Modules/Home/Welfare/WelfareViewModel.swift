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

class WelfareViewModel: ViewModel, ViewModelType {
    
    struct Input {
        //let loginTap: ControlEvent<Void>
    }
    
    struct Output {
        let collectionDataList: BehaviorRelay<[SectionModel<String, String>]>
    }
    
    func transform(input: Input) -> Output {
        let collectionDataDriver = BehaviorRelay<[SectionModel<String, String>]>(value: [])
        apiService.getTechCategoryData(category: "福利", page: 1)
            .startWith()
            .materialize()
            //.trackError(self.error)
            .share()
            .subscribe(onNext: { (event) in
                switch event {
                case .next(let model):
                    collectionDataDriver.accept(self.convertCollectionData(model))
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
        return Output(collectionDataList: collectionDataDriver)
    }
    
    private func convertCollectionData(_ model: CategoryDataModel) -> [SectionModel<String, String>] {
        var dataList = [SectionModel<String, String>]()
        
        guard let data = model.data, !data.isEmpty else {
            return dataList
        }
        dataList = data.map { (gategoryModel) -> SectionModel<String, String> in
            return SectionModel(model: "image", items: [gategoryModel.url ?? ""])
        }
        logDebug("dataListSize= \(dataList.count)")
        return dataList
    }
}
