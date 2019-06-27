//
//  ReadingArtitleModel.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/27.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import ObjectMapper

struct ReadingArticleModel: Mappable {
    var code: Bool
    var data: [ReadingArticleModelData]
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        code <- map["error"]
        data <- map["results"]
    }
}

struct ReadingArticleModelData: Mappable {
    var content: String?
    var published_at: String?
    var title: String?
    var url: String?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        content <- map["content"]
        published_at <- map["published_at"]
        title <- map["title"]
        url <- map["url"]
    }
}
