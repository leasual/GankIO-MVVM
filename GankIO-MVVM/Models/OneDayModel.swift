//
//  TodayModel.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/21.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import ObjectMapper

struct OneDayModel: Mappable {
    var code: Bool?
    var data: OneDayModelData?
    var category: [String]?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        code <- map["error"]
        data <- map["results"]
        category <- map["category"]
    }
}

struct OneDayModelData: Mappable {

    var android: [CommonFeedModel]?
    var iOS: [CommonFeedModel]?
    var app: [CommonFeedModel]?
    var video: [CommonFeedModel]?
    var front: [CommonFeedModel]?
    var outreachResource: [CommonFeedModel]?
    var recommend: [CommonFeedModel]?
    var welfare: [CommonFeedModel]?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        android <- map["Android"]
        iOS <- map["iOS"]
        app <- map["App"]
        video <- map["休息视频"]
        front <- map["前端"]
        outreachResource <- map["拓展资源"]
        recommend <- map ["瞎推荐"]
        welfare <- map["福利"]
    }
}

struct CommonFeedModel: Mappable {
    var _id: String?
    var createdAt: String?
    var publishedAt: String?
    var url: String?
    var who: String?
    var used: Bool?
    var type: String?
    var source: String?
    var desc: String?
    var images: [String]?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        _id <- map["_id"]
        createdAt <- map["createdAt"]
        publishedAt <- map["publishedAt"]
        url <- map["url"]
        who <- map["who"]
        used <- map["used"]
        type <- map["type"]
        source <- map["source"]
        desc <- map["desc"]
        images <- map["images"]
        
    }
}
