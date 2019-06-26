//
//  WelfareController.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/24.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import UIKit
import CHTCollectionViewWaterfallLayout
import RxDataSources
import MJRefresh
import RxCocoa

class WelfareController: ViewController<WelfareViewModel> {
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>?
    var collectionView: UICollectionView!
    var collectionLayout: CHTCollectionViewWaterfallLayout!
    
    
    override func initialize() {
        self.navigationController?.navigationBar.isHidden = true
        setupCollectionView()
    }
    
    override func initBindings() {
        self.collectionView.mj_header.
        let output = viewModel.transform(input: WelfareViewModel.Input(
            pullToRefresh: self.collectionView.mj_header.rx.reachedBottom.asDriver(),
            loadMore: self.collectionView.mj_footer.rx.refreshing.asDriver()))
        
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>> (
            configureCell: { (dataSource, collectionView, index, model) -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: index) as! WelfareItemCell
                cell.imageUrl = model
                return cell
        }
        )
        
        output.collectionDataList.asDriver().drive(collectionView.rx.items(dataSource: dataSource!))
            .disposed(by: rx.disposeBag)
        
        //collectionView?.rx.setDelegate(self).disposed(by: rx.disposeBag)
        //it must use this to set delegate, otherwise app will crash
        collectionView.delegate = self
    }
    
    
    private func setupCollectionView() {
        
        let collectionLayout = CHTCollectionViewWaterfallLayout()
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = .white
        //collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.alwaysBounceVertical = true
        collectionView.register(WelfareItemCell.self, forCellWithReuseIdentifier: "collectionCell")
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
    }
    
    let footerRefresh = MJRefreshAutoFooter()
    let headerRefresh = MJRefreshNormalHeader()
    
}

extension WelfareController: CHTCollectionViewDelegateWaterfallLayout {
    
    @objc func footerLoading() {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(self.view.bounds.width / 2), height: Int(Float.random(in: 200..<300)))
    }
}
