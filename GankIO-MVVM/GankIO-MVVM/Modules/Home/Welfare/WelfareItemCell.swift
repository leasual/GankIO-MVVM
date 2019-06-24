//
//  WelfareCell.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/24.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import SnapKit

class WelfareItemCell: CollectionViewCell {
    
    var imageUrl: String? {
        didSet {
            self.imageView.kf.setImage(with: URL(string: self.imageUrl ?? ""))
        }
    }
    
    override func setupViews() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(200)
        }
    }
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
}
