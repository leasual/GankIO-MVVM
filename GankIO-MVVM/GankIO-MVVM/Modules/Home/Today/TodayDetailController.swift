//
//  TodayDetailController.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/23.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import UIKit
import QMUIKit

class TodayDetailController: ViewController<TodayDetailViewModel> {
    
    open var commendFeeModel: CommonFeedModel?
    
    override func initialize() {
        
        view.addSubview(githubButton)
        githubButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(margin16 + 60)
            make.right.equalToSuperview().offset(-margin16)
            make.height.equalTo(40)
            make.width.greaterThanOrEqualTo(40)
        }
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(margin16)
            make.top.equalTo(githubButton.snp.bottom).offset(margin16)
            make.right.equalToSuperview().offset(-margin16)
        }
    }
    
    override func initBindings() {
        if commendFeeModel == nil {
            return
        }
        descriptionLabel.text = commendFeeModel?.desc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    let descriptionLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: titleSize)
        $0.numberOfLines = 0
    }
    
    let githubButton = QMUIGhostButton().then {
        $0.setTitle("前往Github", for: .normal)
        $0.ghostColor = themeColor
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: margin8, bottom: 0, right: margin8)
    }
}
