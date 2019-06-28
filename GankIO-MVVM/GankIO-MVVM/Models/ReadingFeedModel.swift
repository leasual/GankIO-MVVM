//
//  ReadingFeedModel.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/21.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import ObjectMapper

struct ReadingFeedModel: Mappable {
    var code: Bool?
    var data: [ReadingFeedModelData]?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        code <- map["error"]
        data <- map["results"]
    }
}

struct ReadingFeedModelData: Mappable {
    var _id: String?
    var content: String?
    var cover: String?
    var crawled: String?
    var created_at: String?
    var deleted: Bool?
    var published_at: String?
    var raw: String?
    var title: String?
    var url: String?
    var site: SiteModel?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        _id <- map["_id"]
        content <- map["content"]
        cover <- map["cover"]
        crawled <- map["crawled"]
        created_at <- map["created_at"]
        deleted <- map["deleted"]
        published_at <- map["published_at"]
        raw <- map["raw"]
        title <- map["title"]
        url <- map["url"]
        site <- map["site"]
    }
}

struct SiteModel: Mappable {
    var cat_cn: String?
    var cat_en: String?
    var desc: String?
    var feed_id: String?
    var icon: String?
    var id: String?
    var name: String?
    var url: String?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        cat_cn <- map["cat_cn"]
        cat_en <- map["cat_en"]
        desc <- map["desc"]
        feed_id <- map["feed_id"]
        icon <- map["icon"]
        id <- map["id"]
        name <- map["name"]
        url <- map["url"]
    }
}
