//
//  DepandencyContainer.swift
//  MvvmArchitecture-Swift
//
//  Created by James on 2019/6/19.
//  Copyright © 2019 geekdroid. All rights reserved.
//

import Foundation
import Swinject

struct DependencyContainer {
    fileprivate static let container: Container = {
        return DependencyContainer.getContainer()
    }()
    
    fileprivate static func getContainer() -> Container {
        let container = Container()
        
        // MARK: TodayController
        container.register(APIService.self) { _ in APIService(gankIOAPIProvider: GankIOProvider) }
        container.register(TodayViewModel.self) { resolver in
            TodayViewModel(apiService: resolver.resolve(APIService.self)!)
        }
        container.register(TodayController.self) { resolver in
            TodayController(viewModel: resolver.resolve(TodayViewModel.self)!)
        }
        // MARK: TodayDetailController
        container.register(APIService.self) { _ in APIService(gankIOAPIProvider: GankIOProvider) }
        container.register(TodayDetailViewModel.self) { resolver in
            TodayDetailViewModel(apiService: resolver.resolve(APIService.self)!)
        }
        container.register(TodayDetailController.self) { resolver in
            TodayDetailController(viewModel: resolver.resolve(TodayDetailViewModel.self)!)
        }
        
        return container
    }
    
    static func resolve<Service>(_ serviceType: Service.Type) -> Service {
        return DependencyContainer.container.resolve(serviceType)!
    }
    
    static func resolve<Service, Argument>(_ serviceType: Service.Type, _ argument: Argument) -> Service {
        return DependencyContainer.container.resolve(serviceType, argument: argument)!
    }
}
