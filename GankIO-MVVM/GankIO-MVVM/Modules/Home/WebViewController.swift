//
//  WebViewController.swift
//  GankIO-MVVM
//
//  Created by James on 2019/6/27.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import UIKit

class WebViewController: UIViewController {
    var model: String?
    var type: Int = 2
    var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupIndicatorView()
    }
    
    private func setupWebView() {
        let webView = UIWebView(frame: self.view.frame)
        webView.delegate = self
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        switch type {
        case 1:
            webView.loadHTMLString(model ?? "", baseURL: nil)
            break
        case 2:
            webView.loadRequest(URLRequest(url: URL(string: model ?? "")!))
            break
        default:
            break
        }
    }
    
    private func setupIndicatorView() {
        indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.color = themeColor
        self.view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}

extension WebViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        indicatorView.isHidden = false
        indicatorView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
    }
    
}
