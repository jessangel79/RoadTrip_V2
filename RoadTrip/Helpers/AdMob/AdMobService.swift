//
//  AdMobService.swift
//  RoadTrip
//
//  Created by Angelique Babin on 20/05/2021.
//  Copyright © 2021 Angelique Babin. All rights reserved.
//

import Foundation
import GoogleMobileAds

final class AdMobService {
        
    func setAdMob(_ bannerView: GADBannerView, _ viewController: UIViewController) {
        bannerView.delegate = viewController
        bannerView.adUnitID = Constants.AdMobAdUnitIDTest // Test
        bannerView.rootViewController = viewController
                
        // To comment before AppStore
//        print("Google Mobile Ads SDK version: \(GADMobileAds.sharedInstance().versionNumber)")
//        print(
//          "Google Mobile Ads SDK version: \(GADGetStringFromVersionNumber(GADMobileAds.sharedInstance().versionNumber))"
//        )
        
//        bannerView.load(GADRequest())
    }
    
    func alertUserPresentPrivacyOptionsForm(_ formError: Error, _ self: UIViewController) {
        let alertController = UIAlertController(
            title: formError.localizedDescription, message: "Please try again later.",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alertController, animated: true)
    }

    func adMobCanRequestAdsLoadBannerAd(_ bannerView: GADBannerView, _ view: UIView) {
        if GoogleMobileAdsConsentManager.shared.canRequestAds {
            loadBannerAd(bannerView, view)
        }
    }
    
    func loadBannerAd(_ bannerView: GADBannerView, _ view: UIView) {
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).width
        //        bannerView.adSize = GADAdSizeBanner // test
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.load(GADRequest())
    }
    
}
