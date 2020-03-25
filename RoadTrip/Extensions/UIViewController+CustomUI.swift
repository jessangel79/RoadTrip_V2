//
//  UIViewController+CustomUI.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

// MARK: - Extension to custom buttons and views

extension UIViewController {

    /// custom buttons collection
    func customAllButtons(allButtons: [UIButton], radius: CGFloat, width: CGFloat, colorBackground: UIColor, colorBorder: UIColor) {
        for button in allButtons {
            customButton(button: button, radius: radius, width: width, colorBackground: colorBackground, colorBorder: colorBorder)
        }
    }

    /// custom button
    func customButton(button: UIButton, radius: CGFloat, width: CGFloat, colorBackground: UIColor, colorBorder: UIColor) {
        button.layer.cornerRadius = radius
        button.layer.borderWidth = width
        button.layer.backgroundColor = colorBackground.cgColor
        button.layer.borderColor = colorBorder.cgColor
    }
    
    /// custom labels collection
    func customAllLabels(allLabels: [UILabel], radius: CGFloat, colorBackground: UIColor) {
        for label in allLabels {
            customLabel(label: label, radius: radius, colorBackground: colorBackground)
        }
    }
    
    /// custom label
    func customLabel(label: UILabel, radius: CGFloat, colorBackground: UIColor) {
        label.layer.cornerRadius = radius
        label.layer.backgroundColor = colorBackground.cgColor
    }
    
    /// custom views
    func customView(view: UIView, colorBackground: UIColor, colorBorder: UIColor) {
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1.0
        view.layer.backgroundColor = colorBackground.cgColor
        view.layer.borderColor = colorBorder.cgColor
    }
}
