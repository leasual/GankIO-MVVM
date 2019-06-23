//
//  MainViewModel.swift
//  MvvmArchitecture-Swift
//
//  Created by James on 2019/6/19.
//  Copyright © 2019 geekdroid. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

class TodayViewModel: ViewModel, ViewModelType {
    
    let error = ErrorTracker()
    struct Input {
        //let loginTap: ControlEvent<Void>
    }
    
    struct Output {
        let tableDataList: BehaviorRelay<[SectionType<MultiSectionItem<CommonFeedModel>>]>
    }
    
    func transform(input: Input) -> Output {
        let tableDataDriver = BehaviorRelay<[SectionType<MultiSectionItem<CommonFeedModel>>]>(value: [])
        apiService.getTodayData()
            .startWith()
            .materialize()
            //.trackError(self.error)
            .share()
            .subscribe(onNext: { (event) in
                switch event {
                case .next(let model):
                    tableDataDriver.accept(self.converTableListData(model))
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
        return Output(tableDataList: tableDataDriver)
    }
    
    
    func converTableListData(_ onedayModel: OneDayModel) -> [SectionType<MultiSectionItem<CommonFeedModel>>] {
        var dataList = [SectionType<MultiSectionItem<CommonFeedModel>>]()
        
        // today
        //let calendar = Calendar.current
        //let comp = calendar.dateComponents([.year, .month, .day, .weekday], from: Date())
        
        dataList.append(SectionType<MultiSectionItem<CommonFeedModel>>(header: Localizable.Today.recommend.localized, items: [MultiSectionItem<CommonFeedModel>.TitleSectionItem(title: "4月10号 周日")]))
        
        guard let recommend = onedayModel.data?.recommend, !recommend.isEmpty else {
            return dataList
        }
        dataList.append(SectionType<MultiSectionItem<CommonFeedModel>>(header: Localizable.Today.recommend.localized, items: recommend.map({ (model) -> MultiSectionItem<CommonFeedModel> in
                return MultiSectionItem<CommonFeedModel>.SectionItem(model: model)
        })))
        
        guard let outreachResource = onedayModel.data?.outreachResource, !outreachResource.isEmpty else {
            return dataList
        }
        dataList.append(SectionType<MultiSectionItem<CommonFeedModel>>(header: Localizable.Today.outreachSource.localized, items: outreachResource.map({ (model) -> MultiSectionItem<CommonFeedModel> in
            return MultiSectionItem<CommonFeedModel>.SectionItem(model: model)
        })))
        
        guard let video = onedayModel.data?.video, !video.isEmpty else {
            return dataList
        }
        dataList.append(SectionType<MultiSectionItem<CommonFeedModel>>(header: Localizable.Today.video.localized, items: video.map({ (model) -> MultiSectionItem<CommonFeedModel> in
            return MultiSectionItem<CommonFeedModel>.SectionItem(model: model)
        })))
        
        guard let app = onedayModel.data?.app, !app.isEmpty else {
            return dataList
        }
        dataList.append(SectionType<MultiSectionItem<CommonFeedModel>>(header: Localizable.Today.app.localized, items: app.map({ (model) -> MultiSectionItem<CommonFeedModel> in
            return MultiSectionItem<CommonFeedModel>.SectionItem(model: model)
        })))
        
        guard let android = onedayModel.data?.android, !android.isEmpty else {
            return dataList
        }
        dataList.append(SectionType<MultiSectionItem<CommonFeedModel>>(header: Localizable.Today.android.localized, items: android.map({ (model) -> MultiSectionItem<CommonFeedModel> in
            return MultiSectionItem<CommonFeedModel>.SectionItem(model: model)
        })))
        
        guard let ios = onedayModel.data?.iOS, !ios.isEmpty else {
            return dataList
        }
        dataList.append(SectionType<MultiSectionItem<CommonFeedModel>>(header: Localizable.Today.ios.localized, items: ios.map({ (model) -> MultiSectionItem<CommonFeedModel> in
            return MultiSectionItem<CommonFeedModel>.SectionItem(model: model)
        })))
        
        guard let front = onedayModel.data?.front, !front.isEmpty else {
            return dataList
        }
        dataList.append(SectionType<MultiSectionItem<CommonFeedModel>>(header: Localizable.Today.front.localized, items: front.map({ (model) -> MultiSectionItem<CommonFeedModel> in
            return MultiSectionItem<CommonFeedModel>.SectionItem(model: model)
        })))
        return dataList
    }
    
}
