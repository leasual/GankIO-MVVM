//
//  TodayModel.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/21.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import ObjectMapper

class TodayModel: Mappable {
    
    var android: [FeedModel]?
    var iOS: [FeedModel]?
    var app: [FeedModel]?
    var video: [FeedModel]?
    var front: [FeedModel]?
    var outreachResource: [FeedModel]?
    var recommend: [FeedModel]?
    var welfare: [FeedModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
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

class FeedModel: Mappable {
    var publishAt: String?
    var url: String?
    var who: String?
    var used: Bool?
    var type: String?
    var source: String?
    var desc: String?
    var images: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        publishAt <- map["publishAt"]
        url <- map["url"]
        who <- map["who"]
        used <- map["used"]
        type <- map["type"]
        source <- map["source"]
        desc <- map["desc"]
        images <- map["image"]
        
    }
}
