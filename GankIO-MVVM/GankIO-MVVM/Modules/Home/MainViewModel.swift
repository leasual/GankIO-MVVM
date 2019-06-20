//
//  MainViewModel.swift
//  MvvmArchitecture-Swift
//
//  Created by James on 2019/6/19.
//  Copyright © 2019 geekdroid. All rights reserved.
//

import RxSwift
import RxCocoa

class MainViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let loginTap: ControlEvent<Void>
    }
    
    struct Output {
        let isLoading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let loginResult = input.loginTap
            .flatMapLatest { _ in
                Observable.just(true)
            }
            .asDriverOnErrorJustComplete()
        
        return Output(isLoading: loginResult)
    }
    
    
}
