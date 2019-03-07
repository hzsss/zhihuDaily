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
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    var newsDetail: NewsDetail? {
        didSet {
            let imageURL = URL(string: newsDetail?.image ?? "")
            headerView.setupWebHeaderView(imageURL: imageURL, title: newsDetail?.title, source: newsDetail?.image_source)
            webView.loadHTMLString(concatHTML(css: newsDetail!.css!, body: newsDetail!.body!), baseURL: nil)
        }
    }
    
    var newsExtra: NewsExtra? {
        didSet {
            guard let popularity = newsExtra?.popularity, let comments = newsExtra?.comments else { return }
            likeBtn.setTitle(String(popularity), for: .normal)
            commentBtn.setTitle(String(comments), for: .normal)
        }
    }
    
    var prePoint: CGPoint = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.scrollView.contentInset = UIEdgeInsets(top: 180, left: 0, bottom: 30, right: 0)
        webView.uiDelegate = self
        webView.scrollView.addSubview(headerView)
        
        guard let gesture: UIGestureRecognizer = navigationController?.interactivePopGestureRecognizer,
            let gestureView: UIView = gesture.view else { return }
        gesture.isEnabled = false
        
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(closeVc(_ :)))
        gestureView.addGestureRecognizer(panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self;
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
