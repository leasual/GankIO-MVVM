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

class ReadingArticleViewModel: ViewModel {
    
    func transform(input: Input) -> Output {
        let tableDataList = BehaviorRelay<[ReadingArticleModelData]>(value: [])
        return Output(tableDataList: tableDataList)
    }
}

extension ReadingArticleViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        let tableDataList: BehaviorRelay<[ReadingArticleModelData]>
    }
}
