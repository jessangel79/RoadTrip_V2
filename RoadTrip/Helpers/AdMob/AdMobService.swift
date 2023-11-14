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
    
//    private var isMobileAdsStartCalled = false
//    private var isViewDidAppearCalled = false
    
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

}
