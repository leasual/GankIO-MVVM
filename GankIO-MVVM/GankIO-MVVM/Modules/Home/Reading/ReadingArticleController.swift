//
//  ReadingArticleController.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/27.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources

class ReadingArticleController: ViewController<ReadingArticleViewModel> {
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, ReadingArticleModelData>>?
    
    override func initialize() {
        //self.navigationController?.navigationBar.isHidden = true
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    override func initBindings() {
        let output = viewModel.transform(input: ReadingArticleViewModel.Input())
        
        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ReadingArticleModelData>>(
            configureCell: { dataSource, tableview, index, item in
                    let cell = tableview.dequeueReusableCell(withIdentifier: "artitleCell") as! ReadingArticleCell
                    cell.model = item
                    return cell
            
        })
        output.tableDataList.asDriver().drive(tableView.rx.items(dataSource: dataSource!))
            .disposed(by: rx.disposeBag)
        //selected item
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.tableView.deselectRow(at: indexPath, animated: false)
        }).disposed(by: rx.disposeBag)
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(ReadingItemCell.self, forCellReuseIdentifier: "artitleCell")
        $0.estimatedRowHeight = 80
        //set separator line color and inset
        $0.separatorColor = separatorColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: margin16, bottom: 0, right: 0)
    }
}

extension ReadingArticleController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //auto fit cell size height
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
