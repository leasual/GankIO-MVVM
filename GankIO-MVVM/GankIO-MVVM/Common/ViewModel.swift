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

class ViewModel: NSObject {
   
    var page = 1
    
    deinit {
        logDebug("\(type(of: self)): Deinited")
        logResourcesCount()
    }
}
