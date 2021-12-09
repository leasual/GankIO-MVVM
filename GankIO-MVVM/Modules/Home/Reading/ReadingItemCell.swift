//
//  ReadingCategoryCell.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/27.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import UIKit

class ReadingItemCell: TableViewCell {
    var model: ReadingSubCategoryModelData? {
        didSet {
            self.categoryImageView.sd_setImage(with: URL(string: self.model?.icon ?? ""), completed: nil)
            self.categoryTitleLabel.text = self.model?.title
        }
    }
    override func setupViews() {
        addSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(margin8)
            make.left.equalToSuperview().offset(margin16)
            make.bottom.equalToSuperview().offset(-margin16)
            make.width.height.equalTo(60)
        }
        addSubview(categoryTitleLabel)
        categoryTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(categoryImageView)
            make.left.equalTo(categoryImageView.snp.right).offset(margin16)
            make.right.equalToSuperview().offset(-margin16)
        }
    }
    
    let categoryImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
        $0.contentMode = .scaleAspectFill
    }
    
    let categoryTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: titleSize)
    }
}
