//
//  SectionType.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/22.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import RxDataSources

enum TodaySectionItem {
    case TitleSectionItem(title: String)
    case SectionItem(model: CommonFeedModel)
}

struct TodaySectionType {
    var header: String
    var items: [TodaySectionItem]
}

extension TodaySectionType: SectionModelType {
    
    typealias Item = TodaySectionItem
    
    init(original: TodaySectionType, items: [TodaySectionItem]) {
        self = original
        self.items = items
    }
}
