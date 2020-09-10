//
//  WebViewInformationsViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/09/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import WebKit

final class WebViewInformationsViewController: UIViewController, WKUIDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var safariBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var shareBarButtonItem: UIBarButtonItem!
    
    // MARK: - Actions
    
    @IBAction private func safariBarButtonItemTapped(_ sender: UIBarButtonItem) {
        openSafari(badge)
    }
    
    @IBAction private func shareBarButtonItemTapped(_ sender: UIBarButtonItem) {
        shareContent(website: badge, shareBarButtonItem: shareBarButtonItem, view: self)
    }
    
    // MARK: - Properties
    
    private let forwardBarItem = UIBarButtonItem(title: ">>", style: .plain, target: self,
                                         action: #selector(forwardAction))
    private let backBarItem = UIBarButtonItem(title: "<<", style: .plain, target: self,
                                      action: #selector(backAction))
    private let refreshBarItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
    var badge = String()
        
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let barItemsCollection: [UIBarButtonItem] = [forwardBarItem, refreshBarItem, backBarItem]
        setupWebView(webView: webView, barItemsCollection: barItemsCollection)
        loadWebsite(badge, webView: webView)
    }
    
    // MARK: - Methods
    
    @objc private func forwardAction() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
        
    @objc private func backAction() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc private func refresh() {
        webView.reload()
    }
}
