//
//  ViewController.swift
//  MvvmArchitecture-Swift
//
//  Created by James on 2019/6/19.
//  Copyright © 2019 geekdroid. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Then
import Rswift

class MainController: ViewController<MainViewModel> {

    let thenTestLabel = UILabel().then {
        $0.text = "This is a test"
        $0.textColor = .red
        $0.textAlignment = .center
        $0.font.withSize(18)
    }
    
    let loginBtn = UIButton().then {
        $0.setTitle("Login", for: .normal)
        $0.setTitleColor(.red, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
    }
    
    override func initialize() {
        view.addSubview(thenTestLabel)
        thenTestLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(thenTestLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-30)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
//        GankIOProvider.rx.request(.techCategoryData(category: "iOS", page: 1))
//            .filterSuccessfulStatusCodes()
//            .mapJSON()
//            .subscribe { (event) in
//                logDebug("\(event)")
//                print("\(event)")
//            }.disposed(by: self.rx.disposeBag)
        logDebug("initialize")
    }
    
    override func initBindings() {
    
        let output = viewModel.transform(input: MainViewModel.Input(loginTap: loginBtn.rx.tap))
        output.isLoading
            .flatMapLatest{ isLoading in
                isLoading ? Driver.just(.green) : Driver.just(.black)
            }
        .drive(thenTestLabel.rx.backgroundColor)
            .disposed(by: rx.disposeBag)
    }

}

