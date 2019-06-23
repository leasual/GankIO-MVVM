//
//  TodayItemCell.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/22.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

class TodayItemCell: TableViewCell {
    
    var itemModel: CommonFeedModel? {
        didSet {
            self.titleLabel.text = self.itemModel?.desc ?? ""
            self.publishedDateLabel.text = self.itemModel?.publishedAt?.toDate()?.toFormat("yyyy-MM-dd") ?? ""
            self.typeLabel.text = self.itemModel?.type ?? ""
        }
    }
    
    override func setupViews() {
        backgroundColor = .white
        addSubview(publishedDateLabel)
        publishedDateLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-margin8)
            make.left.equalToSuperview().offset(margin16)
        }
        addSubview(typeLabel)
        typeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-margin16)
            make.bottom.equalToSuperview().offset(-margin8)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(margin8)
            make.bottom.equalTo(publishedDateLabel.snp.top).offset(-margin8)
            make.left.equalTo(margin16)
            make.right.equalTo(-margin16)
        }
        
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: subTitleSize)
        $0.numberOfLines = 0
    }
    
    let publishedDateLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: subContentSize)
    }
    
    let typeLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: subContentSize)
    }
}
