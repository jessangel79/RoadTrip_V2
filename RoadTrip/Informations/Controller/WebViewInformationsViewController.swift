//
//  WebViewInformationsViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/09/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

final class WebViewInformationsViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var safariBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var shareBarButtonItem: UIBarButtonItem!
    
    @IBOutlet private weak var bannerView: GADBannerView!
    
    // MARK: - Properties
    
    private var forwardBarItem: UIBarButtonItem!
    private var backBarItem: UIBarButtonItem!
    private var refreshBarItem: UIBarButtonItem!
    private let adMobService = AdMobService()
//    private var isMobileAdsStartCalled = false
//    private var isViewDidAppearCalled = false
    
    var urlString = String()
    
    // MARK: - Actions
    
    @IBAction private func safariBarButtonItemTapped(_ sender: UIBarButtonItem) {
        openSafari(urlString)
    }
    
    @IBAction private func shareBarButtonItemTapped(_ sender: UIBarButtonItem) {
        shareContent(website: urlString, shareBarButtonItem: shareBarButtonItem, view: self)
    }
        
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        adMobService.setAdMob(bannerView, self)
        setButtonsBarItem()
        let barItemsCollection: [UIBarButtonItem] = [forwardBarItem, refreshBarItem, backBarItem]
        setupWebView(webView: webView, barItemsCollection: barItemsCollection)
        loadWebsite(urlString, webView: webView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adMobService.adMobCanRequestAdsLoadBannerAd(bannerView, view)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { [self] _ in
            adMobService.adMobCanRequestAdsLoadBannerAd(bannerView, view)
        }
    }
    
    // MARK: - Methods
    
    private func setButtonsBarItem() {
        forwardBarItem = UIBarButtonItem(title: ">>", style: .plain, target: self, action: #selector(forwardAction))
        backBarItem = UIBarButtonItem(title: "<<", style: .plain, target: self, action: #selector(backAction))
        refreshBarItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
    }
    
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
