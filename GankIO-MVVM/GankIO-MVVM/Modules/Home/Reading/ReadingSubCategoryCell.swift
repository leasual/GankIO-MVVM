//
//  ReadingSubCategoryCell.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/27.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import UIKit

class ReadingSubCategoryCell: TableViewCell {
    
    var imageUrl: String? {
        didSet {
            self.categoryImageView.sd_setImage(with: URL(string: self.imageUrl ?? ""), completed: nil)
        }
    }
    
    override func setupViews() {
        
        addSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.left.equalToSuperview().offset(margin16)
            make.trailingMargin.equalTo(margin16)
        }
        addSubview(subCategoryLabel)
        subCategoryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(categoryImageView.snp.right).offset(margin8)
            make.right.equalToSuperview().offset(-margin16)
            make.center.equalToSuperview()
        }
    }
    
    let categoryImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    let subCategoryLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: titleSize)
    }
}
