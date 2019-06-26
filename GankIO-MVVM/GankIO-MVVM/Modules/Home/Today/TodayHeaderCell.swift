//
//  TodayHeaderCell.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/22.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import UIKit

class TodayHeaderCell: TableViewCell {
    
    var day: String? {
        didSet {
            self.dayLabel.text = day ?? ""
        }
    }
    
    override func setupViews() {
        addSubview(todayLabel)
        
        todayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(margin16)
            make.left.equalTo(margin16)
            make.right.equalTo(-margin16)
        }
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(todayLabel.snp.bottom).offset(margin8)
            make.left.equalTo(todayLabel.snp.left)
            make.right.equalTo(todayLabel.snp.right)
            make.bottom.equalToSuperview().offset(-margin32)
        }
    }
    
    let dayLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: titleSize)
    }
    
    let todayLabel = UILabel().then {
        $0.text = Localizable.Global.today.localized
        $0.textAlignment = .left
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: bigTitleSize, weight: .bold)
    }
}
