//
//  ReadingCatetoryModel.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/21.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import ObjectMapper

struct ReadingCatetoryModel: Mappable {
    var code: Bool?
    var data: [ReadingCatetoryModelData]?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        code <- map["error"]
        data <- map["results"]
    }
}

struct ReadingCatetoryModelData: Mappable {
    var _id: String?
    var nameEN: String?
    var name: String?
    var rank: Int?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        _id <- map["_id"]
        nameEN <- map["en_name"]
        name <- map["name"]
        rank <- map["rank"]
    }
}
