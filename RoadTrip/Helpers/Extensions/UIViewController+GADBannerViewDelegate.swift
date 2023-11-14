//
//  UIViewController+GADBannerViewDelegate.swift
//  RoadTrip
//
//  Created by Angelique Babin on 20/05/2021.
//  Copyright © 2021 Angelique Babin. All rights reserved.
//

import Foundation

import GoogleMobileAds

// MARK: - Extension GADBannerViewDelegate methods

extension UIViewController: GADBannerViewDelegate {
    
    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print(#function)
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print(#function + ": " + error.localizedDescription)
    }
    
    public func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print(#function)
    }
    
    public func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print(#function)
    }
    
    public func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print(#function)
    }
    
    public func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print(#function)
     }
    
}
