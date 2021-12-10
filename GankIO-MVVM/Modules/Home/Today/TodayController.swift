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

class TodayController: ViewController<TodayViewModel> {
    var dataSource: RxTableViewSectionedReloadDataSource<TodaySectionType>?
    var commonFeedModel: CommonFeedModel?
    
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
        let output = viewModel.transform(input: TodayViewModel.Input())
        
        dataSource = RxTableViewSectionedReloadDataSource<TodaySectionType>(
            configureCell: { dataSource, tableview, index, item in
                switch dataSource[index] {
                    
                case .TitleSectionItem(let day):
                    let cell = tableview.dequeueReusableCell(withIdentifier: "headerCell") as! TodayHeaderCell
                    cell.day = day
                    return cell
                case .SectionItem(let model):
                    let cell = tableview.dequeueReusableCell(withIdentifier: "itemCell") as! TodayItemCell
                    //cell.selectionStyle = .none
                    cell.itemModel = model
                    self.commonFeedModel = model
                    return cell
                }
        },
            titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].header
        })
        output.tableDataList.asDriver().drive(tableView.rx.items(dataSource: dataSource!))
            .disposed(by: rx.disposeBag)
        //selected item
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.tableView.deselectRow(at: indexPath, animated: false)
        }).disposed(by: rx.disposeBag)
        //selected model
        tableView.rx.modelSelected(TodaySectionItem.self).subscribe(onNext: { model in
            switch(model) {
            case .SectionItem(let model):
                guard let url = model.url, !url.isEmpty else  {
                    return
                }
//                let detailVC = DependencyContainer.resolve(WebViewController.self)
//                detailVC.model = url
//                self.navigationController?.pushViewController(detailVC, animated: true)
                break
            case .TitleSectionItem:
                break
            }
        }).disposed(by: rx.disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(TodayHeaderCell.self, forCellReuseIdentifier: "headerCell")
        $0.register(TodayItemCell.self, forCellReuseIdentifier: "itemCell")
        $0.estimatedRowHeight = 80
        //set separator line color and inset
        $0.separatorColor = separatorColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: margin16, bottom: 0, right: 0)
        //hide separator line
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
        //auto fit cell size height
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
}

