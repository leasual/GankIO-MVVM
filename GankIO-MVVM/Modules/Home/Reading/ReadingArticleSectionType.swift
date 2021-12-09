//
//  ReadingArticleSectionType.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/28.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import RxDataSources

enum ReadingArticleSectionItem {
    case TitleSectionItem(title: String)
    case SectionItem(model: ReadingFeedModelData)
}

struct ReadingArticleSectionType {
    var header: String
    var items: [ReadingArticleSectionItem]
}

extension ReadingArticleSectionType: SectionModelType {
    
    typealias Item = ReadingArticleSectionItem
    
    init(original: ReadingArticleSectionType, items: [ReadingArticleSectionItem]) {
        self = original
        self.items = items
    }
}
