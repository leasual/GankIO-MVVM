//
//  UINavigationBar+Sugar.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/23.
//  Copyright © 2019 james.li. All rights reserved.
//
import UIKit

extension UINavigationBar {
    
    public func setTitleAlpha(_ alpha: CGFloat) {
        let color = titleTextAttributes?[.foregroundColor] as? UIColor ?? defaultTitleColor
        setTitleColor(color.withAlphaComponent(alpha))
    }
    
    @available(iOS 11.0, *)
    public func setLargeTitleAlpha(_ alpha: CGFloat) {
        let color = largeTitleTextAttributes?[.foregroundColor] as? UIColor ?? defaultTitleColor
        setLargeTitleColor(color.withAlphaComponent(alpha))
    }
    
    public func setTintAlpha(_ alpha: CGFloat) {
        tintColor = tintColor.withAlphaComponent(alpha)
    }
}

extension UINavigationBar {
    
    var defaultTitleColor: UIColor {
        return barStyle == .default ? UIColor.black : UIColor.white
    }
    
    func setTitleColor(_ color: UIColor) {
        if var titleTextAttributes = titleTextAttributes {
            titleTextAttributes[.foregroundColor] = color
            self.titleTextAttributes = titleTextAttributes
        } else {
            titleTextAttributes = [.foregroundColor: color]
        }
    }
    
    @available(iOS 11.0, *)
    func setLargeTitleColor(_ color: UIColor) {
        if var largeTitleTextAttributes = largeTitleTextAttributes {
            largeTitleTextAttributes[.foregroundColor] = color
            self.largeTitleTextAttributes = largeTitleTextAttributes
        } else {
            self.largeTitleTextAttributes = [.foregroundColor: color]
        }
    }
}

