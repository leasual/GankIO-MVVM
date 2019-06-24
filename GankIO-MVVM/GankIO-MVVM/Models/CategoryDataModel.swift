//
//  CategoryDataModel.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/24.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import ObjectMapper

struct CategoryDataModel: Mappable {
    
    var code: Bool?
    var data: [CommonFeedModel]?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        code <- map["error"]
        data <- map["results"]
    }
}
