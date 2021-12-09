//
//  ReadingSectionType.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/27.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import RxDataSources

enum ReadingSectionItem {
    case TitleSectionItem(title: String)
    case SectionItem(model: ReadingSubCategoryModelData)
}

struct ReadingSectionType {
    var header: String
    var items: [ReadingSectionItem]
}

extension ReadingSectionType: SectionModelType {
    
    typealias Item = ReadingSectionItem
    
    init(original: ReadingSectionType, items: [ReadingSectionItem]) {
        self = original
        self.items = items
    }
}
