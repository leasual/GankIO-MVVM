//
//  LibConfigs.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/21.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import UIKit
import CocoaLumberjack
import QMUIKit

class LibConfigs: NSObject {
    static let shared = LibConfigs()
    
    override init() {
        super.init()
    }
    
    func setupLibs(with window: UIWindow? = nil) {
        setupCocoaLumberjack()
        setupQMUI()
    }
    
    private func setupCocoaLumberjack() {
        DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
        //        DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    
    private func setupQMUI() {
        // QMUIConsole 默认只在 DEBUG 下会显示，作为 Demo，改为不管什么环境都允许显示
        QMUIConsole.sharedInstance().canShow = true
    }
}
