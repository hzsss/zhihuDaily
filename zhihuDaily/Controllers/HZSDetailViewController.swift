//
//  HZSDetailViewController.swift
//  zhihuDaily
//
//  Created by weiphone on 2019/3/5.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class HZSDetailViewController: UIViewController, WKUIDelegate, UIGestureRecognizerDelegate {

    var headerView: WebHeaderView = WebHeaderView(frame: .zero)
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    var prePoint: CGPoint = CGPoint(x: 0, y: 0)
    
    var newsDetail: NewsDetail? {
        didSet {
            let imageURL = URL(string: newsDetail?.image ?? "")
            headerView.setupWebHeaderView(imageURL: imageURL, title: newsDetail?.title, source: newsDetail?.image_source)
            
            if let css = newsDetail?.css, let body = newsDetail?.body {
             webView.loadHTMLString(constructHTML(css: css, body: body), baseURL: nil)
            }
        }
    }
    
    var newsExtra: NewsExtra? {
        didSet {
            guard let popularity = newsExtra?.popularity, let comments = newsExtra?.comments else { return }
            likeBtn.setTitle(String(popularity), for: .normal)
            commentBtn.setTitle(String(comments), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likeBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        commentBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)

        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        webView.scrollView.addSubview(headerView)
        
        guard let gesture: UIGestureRecognizer = navigationController?.interactivePopGestureRecognizer,
            let gestureView: UIView = gesture.view else { return }
        gesture.isEnabled = false
        
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(closeVc(_ :)))
        gestureView.addGestureRecognizer(panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(-20)
            make.left.equalTo(0)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(220)
        }
    }
    
    private func constructHTML(css: [String], body: String) -> String {
        var html = "<html>"
        html += "<head>"
        css.forEach { html += "<link rel=\"stylesheet\" href=\($0)>" }
        html += "<style>img{max-width:320px !important;}</style>"
        html += "<meta name=\"viewport\" content=\"initial-scale=3.0,width=device-width,user-scalable=0,maximum-scale=1.0\"/>"
        html += "</head>"
        html += "<body>"
        html += body
        html += "</body>"
        html += "</html>"
        return html
    }
    
    @objc func closeVc(_ panGesture: UIPanGestureRecognizer) {
        let point: CGPoint = panGesture.translation(in: view)
        
        if point.x > prePoint.x {
            navigationController?.popViewController(animated: true)
        }
        
        prePoint = point
    }
    
    @IBAction func tapBackBtn() {
        navigationController?.popViewController(animated: true)
    }
    
}
