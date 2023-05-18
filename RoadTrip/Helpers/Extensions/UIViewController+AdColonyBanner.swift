//
//  UIViewController+AdColonyBanner.swift
//  RoadTrip
//
//  Created by Angelique Babin on 18/05/2023.
//  Copyright © 2023 Angelique Babin. All rights reserved.
//

import Foundation
import AdColony

// MARK: - Extension AdColony AdView Delegate - All UIViewController

extension UIViewController: AdColonyAdViewDelegate {
    
    // handle new banner
    public func adColonyAdViewDidLoad(_ adView: AdColonyAdView) {}
    
    // handler banner loading failure
    public func adColonyAdViewDidFail(toLoad error: AdColonyAdRequestError) {
        guard let errorLocalizedRecoverySuggestion = error.localizedRecoverySuggestion else { return }
        print("Banner request failed with error: \(error.localizedDescription) and suggestion: \(errorLocalizedRecoverySuggestion)") // error.localizedRecoverySuggestion!
    }
    
    // print AdColony
    public func adColonyAdViewWillOpen(_ adView: AdColonyAdView) {
        print("AdView will open fullscreen view")
    }
    
    public func adColonyAdViewDidClose(_ adView: AdColonyAdView) {
        print("AdView did close fullscreen views")
    }
    
    public func adColonyAdViewWillLeaveApplication(_ adView: AdColonyAdView) {
        print("AdView will send used outside the app")
    }
    
    public func adColonyAdViewDidReceiveClick(_ adView: AdColonyAdView) {
        print("AdView received a click")
    }
}
