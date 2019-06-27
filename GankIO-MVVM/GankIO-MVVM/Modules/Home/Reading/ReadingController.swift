//
//  ReadingController.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/27.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources

class ReadingController: ViewController<ReadingViewModel> {
    var dataSource: RxTableViewSectionedReloadDataSource<TodaySectionType>?

    override func initialize() {
        self.navigationController?.navigationBar.isHidden = true
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    override func initBindings() {
        let output = viewModel.transform(input: ReadingViewModel.Input())
        
        dataSource = RxTableViewSectionedReloadDataSource<TodaySectionType>(
            configureCell: { dataSource, tableview, index, item in
                switch dataSource[index] {
                    
                case .TitleSectionItem(let title):
                    let cell = tableview.dequeueReusableCell(withIdentifier: "categoryCell") as! ReadingCategoryCell
                    cell.title = title
                    return cell
                case .SectionItem(let url):
                    let cell = tableview.dequeueReusableCell(withIdentifier: "subCategoryCell") as! ReadingSubCategoryCell
                    //cell.selectionStyle = .none
                    //cell.imageUrl = url

                    return cell
                }
        },
            titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].header
        })
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(ReadingCategoryCell.self, forCellReuseIdentifier: "categoryCell")
        $0.register(ReadingSubCategoryCell.self, forCellReuseIdentifier: "subCategoryCell")
        $0.estimatedRowHeight = 80
        //set separator line color and inset
        $0.separatorColor = separatorColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: margin16, bottom: 0, right: 0)
    }
}

extension ReadingController: UITabBarDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        let titleLabel = UILabel().then {
            $0.text = self.dataSource?[section].header
            $0.font = UIFont.systemFont(ofSize: bigTitleSize, weight: .bold)
            $0.textColor = .white
            $0.sizeToFit()
        }
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerView)
            make.left.equalTo(headerView).offset(margin16)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //auto fit cell size height
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
