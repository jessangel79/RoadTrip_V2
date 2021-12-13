//
//  UIViewController+CustomUI.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

// MARK: - Extension to custom buttons, views and labels

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
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
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
    
    /// custom imageView for Icon
    func customImageView(imageView: UIImageView, radius: CGFloat, width: CGFloat, colorBackground: UIColor, colorBorder: UIColor) {
        imageView.layer.cornerRadius = radius
        imageView.layer.borderWidth = width
        imageView.layer.backgroundColor = colorBackground.cgColor
        imageView.layer.borderColor = colorBorder.cgColor
    }

    /// custom TableView
    func customTableView(tableView: UITableView, radius: CGFloat, width: CGFloat, colorBorder: UIColor) {
        tableView.layer.cornerRadius = radius
        tableView.layer.borderWidth = width
        tableView.layer.borderColor = colorBorder.cgColor
    }
    
    /// custom TextView
    func customTextView(textView: UITextView, radius: CGFloat) {
        textView.layer.cornerRadius = radius
    }

}

// MARK: - Extension to animate TableView and Cells

extension UIViewController {
    
    /// animate tableView
    func animationTableView(tableView: UITableView) {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.fillMode = CAMediaTimingFillMode.forwards
        transition.duration = 0.5
        transition.subtype = CATransitionSubtype.fromTop
        tableView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
    }
    
    /// animate cells of tableView
    func animationCell(_ tableView: UITableView) {
        tableView.animate(animation: .fade(duration: 0.8))
        let degrees = sin(90.0 * CGFloat.pi/180.0)
        let rotationTransform = CGAffineTransform(rotationAngle: degrees)
        let flipTransform = CGAffineTransform(scaleX: -1, y: -1)
        let customTransform = rotationTransform.concatenating(flipTransform)
        
        let customAnimation = TableViewAnimation.Cell.custom(duration: 0.6, transform: customTransform, options: .transitionFlipFromLeft)
        tableView.animate(animation: customAnimation, completion: nil)
    }

}
