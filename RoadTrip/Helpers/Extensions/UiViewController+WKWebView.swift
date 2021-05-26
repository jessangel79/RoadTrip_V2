//
//  UiViewController+WKWebView.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/09/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import WebKit

// MARK: - Extension to setup webview

extension UIViewController {
    
    func setupWebView(webView: WKWebView, barItemsCollection: [UIBarButtonItem]) {
        setupToolBar()
        setupNavItem(barItemsCollection: barItemsCollection)
    }
        
    private func setupToolBar() {
        navigationController?.toolbar.barTintColor = #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 1)
        navigationController?.isToolbarHidden = false
    }
    
    private func setupNavItem(barItemsCollection: [UIBarButtonItem]) {
        for barItem in barItemsCollection {
            barItem.tintColor = #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1)
            barItem.width = 44
        }
        self.navigationItem.rightBarButtonItems = barItemsCollection
    }
    
    /// open url in webview
    func loadWebsite(_ urlSttring: String, webView: WKWebView) {
        guard let url = URL(string: urlSttring) else { return }
//        print(url)
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    /// open url with safari
    func openSafari(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            presentAlert(typeError: .noWebsite)
        }
    }
    
    func shareContent(website: String, shareBarButtonItem: UIBarButtonItem, view: UIViewController) {
        guard let linkToShare = URL(string: website) else { return }
        let viewController = UIActivityViewController(activityItems: [linkToShare], applicationActivities: [])
        presentShare(viewController, shareBarButtonItem)
    }
    
    /// present UIActivityViewController to share
    private func presentShare(_ viewController: UIActivityViewController, _ shareBarButtonItem: UIBarButtonItem) {
        present(viewController, animated: true)
        if let popOver = viewController.popoverPresentationController {
            popOver.sourceView = self.view
            popOver.barButtonItem = shareBarButtonItem
        }
    }
}
