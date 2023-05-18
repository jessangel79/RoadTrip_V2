//
//  AppDelegate.swift
//  RoadTrip
//
//  Created by Angelique Babin on 07/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
// import GoogleMobileAds
import AdColony
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(modelName: "RoadTrip")
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .all
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setAdColony()
        return true
    }
    
    private func setAdColony() {
        AdColony.configure(withAppID: Constants.AdColony.AppUUID, options: nil) { [] (zones) in // [weak self]
             // config RGPD
//            if UserSettings.userConsent {
//
//            } else {
//
//            }
            
            // Exemple : Précharger une publicité interstitielle
//            let zoneID = Constants.AdColony.Banner1
//            AdColony.requestInterstitial(inZone: zoneID) { (interstitial) in
//                if let interstitial = interstitial {
//                    // La publicité interstitielle a été préchargée avec succès
//                    // Vous pouvez maintenant l'utiliser lorsque vous en avez besoin
//                } else {
//                    // La précharge de la publicité interstitielle a échoué
//                    // Gérez cette situation en conséquence
//                }
//            }
        }
//        AdColony.configure(withAppID: Constants.AdColony.AppUUID,
//                           zoneIDs: [Constants.AdColony.Banner1,
//                                     Constants.AdColony.Interstitial], options: nil) { [] (zones) in
//                // config RGPD [weak self]
//    //            if UserSettings.userConsent {
//    //
//    //            } else {
//    //
//    //            }
//
//        }
    }
}
