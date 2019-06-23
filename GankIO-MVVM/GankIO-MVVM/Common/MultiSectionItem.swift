//
//  TodaySectionItem.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/23.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation

enum MultiSectionItem<T> {
    case TitleSectionItem(title: String)
    case SectionItem(model: T)
}
