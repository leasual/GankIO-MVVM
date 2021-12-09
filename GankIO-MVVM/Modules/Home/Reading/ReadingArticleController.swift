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
import MJRefresh

class ReadingArticleController: ViewController<ReadingArticleViewModel> {
    var dataSource: RxTableViewSectionedReloadDataSource<ReadingArticleSectionType>?
    var category: String?
    
    override func initialize() {
        setupTableView()
    }
    
    override func initBindings() {
        let output = viewModel.transform(input: ReadingArticleViewModel.Input(category: category, pullToRefresh: tableView.mj_header.rx.refreshing.share(), loadMore: tableView.mj_footer.rx.refreshing.share()))
        
        dataSource = RxTableViewSectionedReloadDataSource<ReadingArticleSectionType>(
            configureCell: { dataSource, tableview, index, item in
                switch(dataSource[index]) {
                case .SectionItem(let model):
                    let cell = tableview.dequeueReusableCell(withIdentifier: "artitleCell") as! ReadingArticleCell
                    cell.model = model
                    return cell
                case .TitleSectionItem:
                    return UITableViewCell()
                }
        })
        output.tableDataList.asDriver().drive(tableView.rx.items(dataSource: dataSource!))
            .disposed(by: rx.disposeBag)
        output.endPullToRefresh.asDriver().drive(tableView.mj_header.rx.isRefreshing)
            .disposed(by: rx.disposeBag)
        output.endLoadMore.asDriver().drive(tableView.mj_footer.rx.refreshState)
            .disposed(by: rx.disposeBag)
        //selected item
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.tableView.deselectRow(at: indexPath, animated: false)
        }).disposed(by: rx.disposeBag)
        tableView.rx.modelSelected(ReadingArticleSectionItem.self).subscribe(onNext: { model in
            switch(model) {
            case .SectionItem(let model):
                let controller = DependencyContainer.resolve(WebViewController.self)
                controller.model = model.url
                //controller.type = 1
                self.navigationController?.pushViewController(controller, animated: true)
                break
            case .TitleSectionItem:
                break
            }
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(ReadingArticleCell.self, forCellReuseIdentifier: "artitleCell")
        $0.estimatedRowHeight = 80
        //set separator line color and inset
        $0.separatorColor = separatorColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: margin16, bottom: 0, right: 0)
        $0.mj_header = MJRefreshNormalHeader()
        $0.mj_footer = MJRefreshAutoFooter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
