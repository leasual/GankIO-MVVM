//
//  Localizeble.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/22.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation


enum Localizable {
    enum Global: String, LocalizableDelegate {
        case cancel = "cancel"
        case close = "close"
        case today = "today"
        case welfare = "welfare"
        case tech = "tech"
        case reading = "reading"
    }
    
    enum Today: String, LocalizableDelegate {
        case front = "front"
        case welfare = "welfare"
        case app = "app"
        case android = "android"
        case ios = "ios"
        case recommend = "recommend"
        case video = "video"
        case outreachSource = "outreachSource"
    }
    
//    enum Today: String, LocalizableDelegate {
//
//    }
//    enum Today: String, LocalizableDelegate {
//
//    }
//    enum Today: String, LocalizableDelegate {
//
//    }
}
