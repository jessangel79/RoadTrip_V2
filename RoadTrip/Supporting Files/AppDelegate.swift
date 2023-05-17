//
//  AppDelegate.swift
//  RoadTrip
//
//  Created by Angelique Babin on 07/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
// import GoogleMobileAds
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
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let ads = GADMobileAds.sharedInstance()
//        ads.start { status in
//            // Optional: Log each adapter's initialization latency.
//            let adapterStatuses = status.adapterStatusesByClassName
//            for adapter in adapterStatuses {
//                let adapterStatus = adapter.value
//                NSLog("Adapter Name: %@, Description: %@, Latency: %f", adapter.key,
//                      adapterStatus.description, adapterStatus.latency)
//            }
//        }
        
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID, "04b5955b04ab689e9a3e11e6927572c3" ]
        
        return true
    }
}
