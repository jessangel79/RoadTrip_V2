//
//  AppDelegate.swift
//  RoadTrip
//
//  Created by Angelique Babin on 07/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import GoogleMobileAds
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
        print(
          "Google Mobile Ads SDK version: \(GADGetStringFromVersionNumber(GADMobileAds.sharedInstance().versionNumber))"
        )
        // TODO: - To delete -> to move in class AdMobService
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}
