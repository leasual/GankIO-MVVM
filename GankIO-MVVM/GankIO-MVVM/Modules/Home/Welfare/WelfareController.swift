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

class WelfareController: ViewController<WelfareViewModel> {
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>?
    var collectionView: UICollectionView?
    
    override func initialize() {
        self.navigationController?.navigationBar.isHidden = true
        setupCollectionView()
        view.addSubview(collectionView!)
        collectionView!.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalToSuperview().offset(80)
        }
    }
    
    override func initBindings() {
        let output = viewModel.transform(input: WelfareViewModel.Input())
        
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>> (
            configureCell: { (dataSource, collectionView, index, model) -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: index) as! WelfareItemCell
                cell.imageUrl = model
                return cell
            }
        )

        output.collectionDataList.asDriver().drive(collectionView!.rx.items(dataSource: dataSource!))
            .disposed(by: rx.disposeBag)
        
        collectionView?.rx.setDelegate(self).disposed(by: rx.disposeBag)
    }
    
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionLayout)
        collectionView?.backgroundColor = .white
        collectionView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(WelfareItemCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView?.translatesAutoresizingMaskIntoConstraints = true
    }
    
//    let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionLayout).then {
//        // Collection view attributes
//        $0.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        $0.alwaysBounceVertical = true
//        $0.register(WelfareItemCell.self, forCellWithReuseIdentifier: "collectionCell")
//    }
    
    let collectionLayout = CHTCollectionViewWaterfallLayout().then {
        $0.minimumColumnSpacing = 1.0
        $0.minimumInteritemSpacing = 1.0
    }
    
}

extension WelfareController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 500, height: 500)
    }
    
    
}
