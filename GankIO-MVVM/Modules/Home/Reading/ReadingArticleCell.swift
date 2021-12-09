//
//  ReadingArticleCell.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/27.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import SnapKit
import SwiftDate

class ReadingArticleCell: TableViewCell {
    
    var model: ReadingFeedModelData? {
        didSet {
            self.articleImageView.sd_setImage(with: URL(string: self.model?.site?.icon ?? ""), completed: nil)
            self.coverImageView.sd_setImage(with: URL(string: self.model?.cover ?? ""), completed: nil)
            self.typeLabel.text = self.model?.site?.name
            self.titleLabel.text = self.model?.title
            self.publishDateLabel.text = self.model?.published_at?.toDate()?.toFormat("yyyy-MM-dd") ?? ""
        }
    }
    override func setupViews() {
        addSubview(articleImageView)
        articleImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(margin8)
            make.left.equalToSuperview().offset(margin16)
            make.width.height.equalTo(30)
        }
        addSubview(typeLabel)
        typeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(articleImageView.snp.top)
            make.left.equalTo(articleImageView.snp.right).offset(margin8)
            make.bottom.equalTo(articleImageView.snp.bottom)
            make.centerY.equalTo(articleImageView)
        }
        addSubview(publishDateLabel)
        publishDateLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-margin16)
            make.bottom.equalToSuperview().offset(-margin8)
        }
        addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-margin16)
            make.top.equalTo(articleImageView.snp.bottom).offset(margin8)
            make.centerY.equalToSuperview()
            make.bottom.equalTo(publishDateLabel.snp.top).offset(-margin8)
            make.width.height.equalTo(80)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(articleImageView.snp.left)
            make.top.equalTo(articleImageView.snp.bottom).offset(margin8)
            make.right.equalTo(coverImageView.snp.left).offset(-margin16)
            make.height.greaterThanOrEqualTo(30)
            make.bottom.equalTo(publishDateLabel.snp.top).offset(-margin8)
        }
    }
    
    let articleImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.contentMode = .scaleAspectFill
    }
    
    let typeLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: subTitleSize)
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: titleSize)
    }
    
    let publishDateLabel = UILabel().then {
        $0.textColor = .gray
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: contentSize)
    }
    
    let coverImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.contentMode = .scaleAspectFill
    }
}
