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
        // MARK: WelfareController
        container.register(APIService.self) { _ in APIService(gankIOAPIProvider: GankIOProvider) }
        container.register(WelfareViewModel.self) { resolver in
            WelfareViewModel(apiService: resolver.resolve(APIService.self)!)
        }
        container.register(WelfareController.self) { resolver in
            WelfareController(viewModel: resolver.resolve(WelfareViewModel.self)!)
        }
        //MARK: WebViewController
        container.register(WebViewController.self) { _ in WebViewController()}
        
        //MARK: ReadingController
        container.register(APIService.self) { _ in APIService(gankIOAPIProvider: GankIOProvider) }
        container.register(ReadingViewModel.self) { resolver in
            ReadingViewModel(apiService: resolver.resolve(APIService.self)!)
        }
        container.register(ReadingController.self) { resolver in
            ReadingController(viewModel: resolver.resolve(ReadingViewModel.self)!)
        }
        //MARK: ReadingArticleController
        container.register(APIService.self) { _ in APIService(gankIOAPIProvider: GankIOProvider) }
        container.register(ReadingArticleViewModel.self) { resolver in
            ReadingArticleViewModel(apiService: resolver.resolve(APIService.self)!)
        }
        container.register(ReadingArticleController.self) { resolver in
            ReadingArticleController(viewModel: resolver.resolve(ReadingArticleViewModel.self)!)
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
