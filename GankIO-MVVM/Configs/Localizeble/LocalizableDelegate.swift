//
//  LocalizableDelegate.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/22.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation

protocol LocalizableDelegate {
    var rawValue: String { get }    //localize key
    var table: String? { get }
    var localized: String { get }
}
extension LocalizableDelegate {
    
    //returns a localized value by specified key located in the specified table
    var localized: String {
        return Bundle.main.localizedString(forKey: rawValue, value: nil, table: table)
    }
    
    // file name, where to find the localized key
    // by default is the Localizable.string table
    var table: String? {
        return nil
    }
}
