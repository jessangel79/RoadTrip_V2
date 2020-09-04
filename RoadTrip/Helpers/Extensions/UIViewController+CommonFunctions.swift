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
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            presentAlert(typeError: .noWebsite)
        }
    }
}

// MARK: - Extension to set priceLevel in String

//extension UIViewController {
//    func priceLevelString(_ priceLevel: Int) -> String {
//        switch priceLevel {
//        case 1:
//            return "€"
//        case 2:
//            return "€€"
//        case 3:
//            return "€€€"
//        case 4:
//            return "€€€€"
//        default:
//            return "N/A"
//        }
//    }
//}

//extension UIViewController {
//    func importanceString(_ importance: String) -> String? {
//        switch importance {
//        case "0.1":
//            return Importance.one.importanceFunc()
//        case "0.2":
//            return Importance.two.importanceFunc()
//        case "0.3":
//            return Importance.three.importanceFunc()
//        case "0.4":
//            return Importance.four.importanceFunc()
//        case "0.5":
//             return Importance.five.importanceFunc()
//        case "0.6":
//             return Importance.six.importanceFunc()
//        case "0.7":
//             return Importance.seven.importanceFunc()
//        case "0.8":
//             return Importance.eight.importanceFunc()
//        case "0.9":
//             return Importance.nine.importanceFunc()
//        default:
//            return Importance.noa.importanceFunc()
//        }
//    }
//}
