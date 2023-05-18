//
//  WebViewInformationsViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/09/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import WebKit
import AdColony
// import GoogleMobileAds

final class WebViewInformationsViewController: UIViewController, WKUIDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var safariBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var shareBarButtonItem: UIBarButtonItem!
    
    @IBOutlet private weak var bannerView: UIView!
    
    // MARK: - Properties
    
    private let forwardBarItem = UIBarButtonItem(title: ">>", style: .plain, target: WebViewInformationsViewController.self,
                                         action: #selector(forwardAction))
    private let backBarItem = UIBarButtonItem(title: "<<", style: .plain, target: WebViewInformationsViewController.self,
                                      action: #selector(backAction))
    private let refreshBarItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: WebViewInformationsViewController.self, action: #selector(refresh))
    private var adColonyService = AdColonyService()

//    private let adMobService = AdMobService()
    
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
//        adMobService.setAdMob(bannerView, self)
        adColonyService.destroyAd()
        adColonyService.requestBannerAd(Constants.AdColony.Banner1, self) // 1
        let barItemsCollection: [UIBarButtonItem] = [forwardBarItem, refreshBarItem, backBarItem]
        setupWebView(webView: webView, barItemsCollection: barItemsCollection)
        loadWebsite(urlString, webView: webView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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


// MARK: - Extension AdColony AdView Delegate

extension WebViewInformationsViewController {
    
    override func adColonyAdViewDidLoad(_ adView: AdColonyAdView) {
        adColonyService.destroyAd()
        let placementSize = self.bannerView.frame.size
        adView.frame = CGRect(x: 0, y: 0, width: placementSize.width, height: placementSize.height)
        self.bannerView.addSubview(adView)
        adColonyService.banner = adView
    }
}
