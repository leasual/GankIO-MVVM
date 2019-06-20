//
//  ViewController.swift
//  MvvmArchitecture-Swift
//
//  Created by James on 2019/6/19.
//  Copyright © 2019 geekdroid. All rights reserved.
//

import UIKit
//import Then
import SnapKit

class ViewController<T: ViewModelType>: UIViewController {
    internal let viewModel: T!
    
    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        initBindings()
    }
    
    deinit {
        logDebug("\(type(of: self)): Deinited")
        logResourcesCount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        logDebug("\(type(of: self)) Received Memory Warning")
    }
    
    // MARK init view
    open func initialize() {
        
    }
    
    // MARK binding viewModel
    open func initBindings() {
        
    }
    
}
