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
import ATGMediaBrowser

class WelfareController: ViewController<WelfareViewModel> {
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>?
    var collectionView: UICollectionView!
    var collectionLayout: CHTCollectionViewWaterfallLayout!
    var output: WelfareViewModel.Output!
    var currentItem: Int = 0
    
    override func initialize() {
        self.navigationController?.navigationBar.isHidden = true
        setupCollectionView()
    }
    
    override func initBindings() {
        
        output = viewModel.transform(input: WelfareViewModel.Input(
            pullToRefresh: collectionView.mj_header.rx.refreshing.share(),
            loadMore: collectionView.mj_footer.rx.refreshing.share()))
        
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>> (
            configureCell: { (dataSource, collectionView, index, model) -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: index) as! WelfareItemCell
                cell.imageUrl = model
                return cell
        })
        
        output.collectionDataList.asDriver().drive(collectionView.rx.items(dataSource: dataSource!))
            .disposed(by: rx.disposeBag)
        output.endPullToRefresh.asDriver().drive(collectionView.mj_header.rx.isRefreshing)
            .disposed(by: rx.disposeBag)
        output.endLoadMore.asDriver().drive(collectionView.mj_footer.rx.refreshState)
            .disposed(by: rx.disposeBag)
        
        //        collectionView.rx.itemSelected.subscribe(onNext: { indexPath in
        //            self.collectionView.deselectItem(at: indexPath, animated: false)
        //            logDebug("welfare item selected")
        //        }).disposed(by: rx.disposeBag)
        //        collectionView.rx.modelSelected(String.self).subscribe(onNext: { model in
        //            logDebug("welfare model selected")
        //            let controller = ImageBrowserController()
        //            controller.url = model
        //            controller.size = 10
        //            self.navigationController?.present(controller, animated: true, completion: nil)
        //        }).disposed(by: rx.disposeBag)
        
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
        
        collectionView.mj_header = MJRefreshNormalHeader()
        collectionView.mj_footer = MJRefreshAutoFooter()
    }
    
}

extension WelfareController: UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout, MediaBrowserViewControllerDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(self.view.bounds.width / 2), height: Int(Float.random(in: 200..<350)))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        self.currentItem = indexPath.row
        logDebug("select item index= \(self.currentItem)")
        let mediaBrowser = MediaBrowserViewController(dataSource: self)
        mediaBrowser.shouldShowPageControl = false
        mediaBrowser.contentTransformer = DefaultContentTransformers.verticalZoomInOut
        mediaBrowser.gestureDirection = .vertical
        
        present(mediaBrowser, animated: true, completion: nil)
        
    }
    
    func numberOfItems(in mediaBrowser: MediaBrowserViewController) -> Int {
        return viewModel.count
    }
    
    func mediaBrowser(_ mediaBrowser: MediaBrowserViewController, imageAt index: Int, completion: @escaping MediaBrowserViewControllerDataSource.CompletionBlock) {
        logDebug("mediaBrowser index= \(index)")
        let imageView = UIImageView()
        let url = self.output.collectionDataList.value[0].items[index]
        imageView.sd_setImage(with: URL(string: url)) { (uiImage, error, type, url) in
            if let _ = error {
                imageView.image = UIImage(named: "imageDefault\(Int.random(in: 1..<12))")
            }
        }
        completion(index, imageView.image, ZoomScale.default, nil)
    }
}
