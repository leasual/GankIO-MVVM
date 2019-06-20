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
        
        // MARK: MainController
        container.register(MainViewModel.self) { _ in MainViewModel() }
        container.register(MainController.self) { resolver in
            MainController(viewModel: resolver.resolve(MainViewModel.self)!)
            
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
