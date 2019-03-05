//
//  HZSDetailViewController.swift
//  zhihuDaily
//
//  Created by weiphone on 2019/3/5.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit
import WebKit

class HZSDetailViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    var webView: WKWebView!
    
    var newsDetail: NewsDetail? {
        didSet {
            titleLabel.text = newsDetail?.title
            sourceLabel.text = newsDetail?.image_source
            
            let imageURL = URL(string: newsDetail?.image ?? "")
            bgImageView.kf.setImage(with: imageURL)
            webView.loadHTMLString(concatHTML(css: newsDetail!.css!, body: newsDetail!.body!), baseURL: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view.addSubview(webView)
    }
    
    override func viewDidLayoutSubviews() {
        webView.frame = CGRect(x: 0,
                               y: bgImageView.frame.maxY,
                               width: view.bounds.width,
                               height: view.bounds.height - bgImageView.bounds.height)
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
