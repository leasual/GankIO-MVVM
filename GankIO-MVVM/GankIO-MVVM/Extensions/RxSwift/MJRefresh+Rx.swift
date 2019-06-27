//
//  MJRefresh+Rx.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/27.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

public extension Reactive where Base: MJRefreshComponent {
    // 正在刷新事件
    var refreshing: ControlEvent<Void> {
        
        let source: Observable<Void> = Observable.create {
            [weak control = self.base] observer in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
}

public extension Reactive where Base: MJRefreshHeader {
    var beginRefreshing: Binder<Void> {
        return Binder(base) { header, _ in
            header.beginRefreshing()
        }
    }
    
    var isRefreshing: Binder<Bool> {
        return Binder(base) { header, refresh in
            if refresh {
                header.beginRefreshing()
            } else {
                header.endRefreshing()
            }
        }
    }
}

/**
 /** 提示没有更多的数据 */
 - (void)endRefreshingWithNoMoreData;
 /** 重置没有更多的数据（消除没有更多数据的状态） */
 - (void)resetNoMoreData;
 */

public extension Reactive where Base: MJRefreshFooter {
    var refreshState: Binder<FooterRefreshState> {
        return Binder(base) { footer, state in
            switch state {
            case .none:
                footer.isHidden = true
            case .noMoreData:
                footer.isHidden = false
                footer.endRefreshingWithNoMoreData()
            default:
                footer.isHidden = false
                footer.resetNoMoreData()
            }
        }
    }
}

// MARK: - 底部刷新状态
public enum FooterRefreshState: Int, CustomStringConvertible {
    case normal
    case noMoreData
    case none
    
    public var description: String {
        switch self {
        case .normal:
            return "默认状态"
        case .noMoreData:
            return "没有更多数据"
        case .none:
            return "隐藏"
        }
    }
}

