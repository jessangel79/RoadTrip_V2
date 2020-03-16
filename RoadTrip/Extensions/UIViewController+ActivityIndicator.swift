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
    func toggleActivityIndicator(shown: Bool, activityIndicator: UIActivityIndicatorView, validateButton: UIButton) {
        activityIndicator.isHidden = !shown
        validateButton.isHidden = shown
    }
    
    func toggleActivityIndicator(shown: Bool, activityIndicator: UIActivityIndicatorView, tableview: UITableView) {
        activityIndicator.isHidden = !shown
        tableview.isHidden = shown
    }
    
//    func toggleActivityIndicator(shown: Bool, activityIndicator: UIActivityIndicatorView, view: UIView, textView1: UITextView, textView2: UITextView) {
//        activityIndicator.isHidden = !shown
//        view.isHidden = shown
//        textView1.isHidden = shown
//        textView2.isHidden = shown
//    }
}
