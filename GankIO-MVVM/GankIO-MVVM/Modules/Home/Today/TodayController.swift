//
//  ViewController.swift
//  MvvmArchitecture-Swift
//
//  Created by James on 2019/6/19.
//  Copyright © 2019 geekdroid. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Then
import Rswift
import RxDataSources
import Cards

class TodayController: ViewController<TodayViewModel> {
    var dataSource: RxTableViewSectionedReloadDataSource<SectionType<MultiSectionItem<CommonFeedModel>>>?
    var commonFeedModel: CommonFeedModel?
    
    override func initialize() {
        self.navigationController?.navigationBar.isHidden = true
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    override func initBindings() {
        let output = viewModel.transform(input: TodayViewModel.Input())
        
        dataSource = RxTableViewSectionedReloadDataSource<SectionType<MultiSectionItem<CommonFeedModel>>>(
            configureCell: { dataSource, tableview, index, item in
                switch dataSource[index] {
                    
                case .TitleSectionItem(let day):
                    let cell = tableview.dequeueReusableCell(withIdentifier: "headerCell") as! TodayHeaderCell
                    cell.day = day
                    return cell
                case .SectionItem(let model):
                    let cell = tableview.dequeueReusableCell(withIdentifier: "itemCell") as! TodayItemCell
                    cell.selectionStyle = .none
                    cell.itemModel = model
                    self.commonFeedModel = model
//                    cell.articleCard.shouldPresent(detailVC, from: self, fullscreen: true)
                    return cell
                }
            },
            titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].header
        })
        output.tableDataList.asDriver().drive(tableView.rx.items(dataSource: dataSource!))
        .disposed(by: rx.disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(TodayHeaderCell.self, forCellReuseIdentifier: "headerCell")
        $0.register(TodayItemCell.self, forCellReuseIdentifier: "itemCell")
        $0.register(TodayCardItemCell.self, forCellReuseIdentifier: "cardItemCell")
        $0.estimatedRowHeight = 80
        //设置分割线位置和颜色以及大小
        $0.separatorColor = .lightGray
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //隐藏分割线
        //$0.separatorStyle = .none
    }
    
}

extension TodayController: UITableViewDelegate {
    
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
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DependencyContainer.resolve(TodayDetailController.self)
        detailVC.commendFeeModel = self.commonFeedModel
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

