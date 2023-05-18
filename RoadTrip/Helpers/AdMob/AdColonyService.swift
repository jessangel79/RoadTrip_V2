//
//  AdColonyService.swift
//  RoadTrip
//
//  Created by Angelique Babin on 18/05/2023.
//  Copyright © 2023 Angelique Babin. All rights reserved.
//

import Foundation
import AdColony

final class AdColonyService {
    
    weak var banner: AdColonyAdView?
    weak var interstitial: AdColonyInterstitial?
    
    // MARK: - Banner
    
    func requestBannerAd(_ inZone: String, _ viewController: UIViewController) {
        AdColony.requestAdView(inZone: inZone, with: kAdColonyAdSizeBanner, viewController: viewController, andDelegate: viewController)
    }
    
    func requestMediumRectBannerAd(_ inZone: String, _ viewController: UIViewController) {
        AdColony.requestAdView(inZone: inZone, with: kAdColonyAdSizeMediumRectangle, viewController: viewController, andDelegate: viewController)
    }
    
//    func requestBannerAd1(_ viewController: UIViewController) { // "vzb85522c99b784ad1a1"
//        AdColony.requestAdView(inZone: Cst.AdColony.Banner1, with: kAdColonyAdSizeBanner, viewController: viewController, andDelegate: viewController)
//    }
//
//    func requestBannerAd2(_ viewController: UIViewController) { // "vz6aec3496ad0343b08a"
//        AdColony.requestAdView(inZone: Cst.AdColony.Banner2, with: kAdColonyAdSizeBanner, viewController: viewController, andDelegate: viewController)
//    }
    
    func destroyAd() {
        if let oldBanner = banner {
            oldBanner.destroy()
        }
    }
    
    // MARK: - Interstitial
    
    func requestInterstitial(_ inZone: String, _ viewController: UIViewController) { // "vzf7d1df791b5446a5b7" Cst.AdColony.Interstitial
        AdColony.requestInterstitial(inZone: inZone, options: nil, andDelegate: viewController)
    }
    
    func showAd(_ viewController: UIViewController) {
        if let interstitial = interstitial, !interstitial.expired {
            interstitial.show(withPresenting: viewController)
        }
    }
}
