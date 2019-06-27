//
//  ReadingCategoryCell.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/27.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import UIKit

class ReadingCategoryCell: TableViewCell {
    var title: String? {
        didSet {
            self.categoryLabel.text = self.title ?? ""
        }
    }
    override func setupViews() {
       addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(margin16)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-margin16)
        }
    }
    
    let categoryLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: titleSize)
    }
}
