//
//  HZSDetailViewController.swift
//  zhihuDaily
//
//  Created by weiphone on 2019/3/5.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit
import WebKit

class HZSDetailViewController: UIViewController, WKUIDelegate, UIGestureRecognizerDelegate {

    var headerView: WebHeaderView = WebHeaderView(frame: .zero)
    
    var webView: WKWebView!
    
    var newsDetail: NewsDetail? {
        didSet {
            let imageURL = URL(string: newsDetail?.image ?? "")
            headerView.setupWebHeaderView(imageURL: imageURL, title: newsDetail?.title, source: newsDetail?.image_source)
            webView.loadHTMLString(concatHTML(css: newsDetail!.css!, body: newsDetail!.body!), baseURL: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.scrollView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        webView.uiDelegate = self
        view.addSubview(webView)
        
        webView.scrollView.addSubview(headerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self;
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
    }
    
    override func viewDidLayoutSubviews() {
        webView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        headerView.frame = CGRect(x: 0, y: -200, width: view.bounds.width, height: 200)
    }
    
    private func concatHTML(css: [String], body: String) -> String {
        var html = "<html>"
        html += "<head>"
        css.forEach { html += "<link rel=\"stylesheet\" href=\($0)>" }
        html += "<style>img{max-width:320px !important;}</style>"
        html += "</head>"
        html += "<body>"
        html += body
        html += "</body>"
        html += "</html>"
        return html
    }
}
