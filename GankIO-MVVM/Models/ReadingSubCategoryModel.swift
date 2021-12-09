//
//  ReadingSubCategoryModel.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/21.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import ObjectMapper

struct ReadingSubCategoryModel: Mappable {
    var code: Bool?
    var data: [ReadingSubCategoryModelData]?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        code <- map["error"]
        data <- map["results"]
    }
}
struct ReadingSubCategoryModelData: Mappable {
    var _id: String?
    var created_at: String?
    var icon: String?
    var id: String?
    var title: String?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        _id <- map["_id"]
        created_at <- map["created_at"]
        icon <- map["icon"]
        id <- map["id"]
        title <- map["title"]
    }
}
