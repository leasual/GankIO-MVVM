//
//  TodayCardItemCell.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/23.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import Cards
import Kingfisher
import SnapKit

class TodayCardItemCell: TableViewCell {
 
    var itemModel: CommonFeedModel? {
        didSet {
            self.articleCard.title = self.itemModel?.desc ?? ""
            self.articleCard.subtitle = self.itemModel?.publishedAt?.toDate()?.toFormat("yyyy-MM-dd") ?? ""

            self.articleCard.category = self.itemModel?.type ?? ""
            self.articleCard.textColor = .white
//            guard let url = self.itemModel?.images?[0] else {
//                self.articleCard.backgroundImage = R.image.backgroundImage()
//                return
//            }
//            self.articleCard.backgroundIV.kf.setImage(with: URL(string: url))
            self.articleCard.backgroundImage = R.image.backgroundImage()
            self.articleCard.backgroundIV.contentMode = .scaleAspectFill
        }
    }
    
    override func setupViews() {
        addSubview(articleCard)
        articleCard.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(margin16)
            make.right.equalToSuperview().offset(-margin16)
            make.height.greaterThanOrEqualTo(200)
            make.top.equalToSuperview().offset(margin8)
            make.bottom.equalToSuperview().offset(-margin8)
        }
    }
    
    let articleCard = CardArticle().then {
        $0.hasParallax = true
        $0.shadowBlur = 4
    }
}
