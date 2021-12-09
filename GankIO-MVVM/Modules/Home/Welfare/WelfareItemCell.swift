//
//  WelfareCell.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/24.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import SnapKit
import SDWebImage

class WelfareItemCell: CollectionViewCell {
    
    var imageUrl: String? {
        didSet {
            self.imageView.sd_setImage(with: URL(string: self.imageUrl ?? "")) { (uiImage, error, type, url) in
                if let _ = error {
                    self.imageView.image = UIImage(named: "imageDefault\(Int.random(in: 1..<12))")
                }
            }
        }
    }
    
    override func setupViews() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.right.bottom.equalToSuperview()
        }
    }
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
}
