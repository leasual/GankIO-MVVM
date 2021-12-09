//
//  ImageBrowserController.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/27.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import UIKit
import ATGMediaBrowser

class ImageBrowserController: UIViewController {
    var size: Int = 0
    var url: String?
    
    override func viewDidLoad() {
        let mediaBrowser = MediaBrowserViewController(dataSource: self)
        present(mediaBrowser, animated: true, completion: nil)
    }
    
}

extension ImageBrowserController: MediaBrowserViewControllerDataSource {
    
    
    
    func numberOfItems(in mediaBrowser: MediaBrowserViewController) -> Int {
        return size
    }
    
    func mediaBrowser(_ mediaBrowser: MediaBrowserViewController, imageAt index: Int, completion: @escaping MediaBrowserViewControllerDataSource.CompletionBlock) {
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: url ?? "")) { (uiImage, error, type, url) in
            if let _ = error {
                imageView.image = UIImage(named: "imageDefault\(Int.random(in: 1..<12))")
            }
        }
        completion(index , imageView.image, ZoomScale.default, nil)
    }
    
}
