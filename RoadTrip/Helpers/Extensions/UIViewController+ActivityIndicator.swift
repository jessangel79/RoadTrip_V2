//
//  UIViewController+ActivityIndicator.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

// MARK: - Extension to manage the ActivityIndicator

extension UIViewController {
    
    /// manage the ActivityIndicator with UIButton
    func toggleActivityIndicator(shown: Bool, activityIndicator: UIActivityIndicatorView, validateButton: UIButton) {
        activityIndicator.isHidden = !shown
        validateButton.isHidden = shown
    }
    
    /// manage the ActivityIndicator with UITableView
    func toggleActivityIndicator(shown: Bool, activityIndicator: UIActivityIndicatorView, tableview: UITableView) {
        activityIndicator.isHidden = !shown
        tableview.isHidden = shown
    }
}
