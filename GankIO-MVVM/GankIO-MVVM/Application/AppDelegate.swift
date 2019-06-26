//
//  AppDelegate.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/20.
//  Copyright © 2019 james.li. All rights reserved.
//

import UIKit
import CBFlashyTabBarController


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        LibConfigs.shared.setupLibs()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        let rootController = GKNavigationController(rootViewController: createTabBarController())
        rootController.navigationBar.isHidden = true
        self.window?.rootViewController = rootController
        
        return true
    }
    
    private func createTabBarController() -> CBFlashyTabBarController {
        CBFlashyTabBar.appearance().tintColor = themeColor
        CBFlashyTabBar.appearance().barTintColor = .white
        
        let eventsVC = DependencyContainer.resolve(TodayController.self)
        eventsVC.tabBarItem = UITabBarItem(title: R.string.localizable.today(), image: R.image.eventsImage(), tag: 0)
        let searchVC = DependencyContainer.resolve(WelfareController.self)
        searchVC.tabBarItem = UITabBarItem(title: R.string.localizable.welfare(), image: R.image.searchImage(), tag: 0)
        let activityVC = UIViewController()//DependencyContainer.resolve(TodayController.self)
        activityVC.tabBarItem = UITabBarItem(title: R.string.localizable.reading(), image: R.image.highlightsImage(), tag: 0)
        let settingsVC = UIViewController()//DependencyContainer.resolve(TodayController.self)
        settingsVC.tabBarItem = UITabBarItem(title: R.string.localizable.tech(), image: R.image.settingsImage(), tag: 0)
        //settingsVC.inverseColor()
        
        let tabBarController = CBFlashyTabBarController()
        tabBarController.viewControllers = [eventsVC, searchVC, activityVC, settingsVC]
        return tabBarController
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
    }


}

