//
//  UIViewController+CommonFunctions.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

// MARK: - Extension to open url

extension UIViewController {
    func openSafari(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - Extension to delete favorites and manage the button of favorites

extension UIViewController {
    
    /// Delete place
    func deletePlace(placeName: String?, address: String?, coreDataManager: CoreDataManager?, barButtonItem: UIBarButtonItem) {
        coreDataManager?.deletePlace(placeName: placeName ?? "", address: address ?? "")
        setupBarButtonItem(color: #colorLiteral(red: 0.2532418037, green: 0.05658567593, blue: 0.2074308577, alpha: 1), barButtonItem: barButtonItem)

        debugCoreDataPlace(nameDebug: "Place deleted", coreDataManager: coreDataManager)
    }

    /// Manage the button bookmark of places saved
    func setupBarButtonItem(color: UIColor, barButtonItem: UIBarButtonItem) {
        barButtonItem.tintColor = color
        navigationItem.rightBarButtonItem = barButtonItem
    }
}

// MARK: - Extension to set priceLevel in String

extension UIViewController {
    func priceLevelString(_ priceLevel: Int) -> String {
        switch priceLevel {
        case 1:
            return "€"
        case 2:
            return "€€"
        case 3:
            return "€€€"
        case 4:
            return "€€€€"
        default:
            return "N/A"
        }
    }
}
