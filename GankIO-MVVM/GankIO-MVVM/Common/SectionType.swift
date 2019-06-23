//
//  SectionType.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/22.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import RxDataSources


struct SectionType<T> {
    var header: String
    var items: [T]
}

extension SectionType: SectionModelType {
    
    typealias Item = T
    
    init(original: SectionType, items: [T]) {
        self = original
        self.items = items
    }
}
