//
//  UITableViewCell.swift
//  RoadTrip
//
//  Created by Angelique Babin on 20/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

// MARK: - Extension to custom views of TableViewCell

extension UITableViewCell {
    
    /// custom label
    func customLabelCell(label: UILabel, radius: CGFloat, width: CGFloat, colorBackground: UIColor, colorBorder: UIColor) {
        label.layer.cornerRadius = radius
        label.layer.borderWidth = width
        label.layer.backgroundColor = colorBackground.cgColor
        label.layer.borderColor = colorBorder.cgColor
    }
    
    /// custom labels collection
    func customLabelsCell(labels: [UILabel], radius: CGFloat, width: CGFloat, colorBackground: UIColor, colorBorder: UIColor) {
        for label in labels {
            customLabelCell(label: label, radius: radius, width: width, colorBackground: colorBackground, colorBorder: colorBorder)
        }
    }
    
    /// custom view
    func customViewCell(view: UIView, colorBorder: UIColor, colorBackground: UIColor, width: CGFloat, radius: CGFloat) {
        view.layer.borderColor = colorBorder.cgColor
        view.layer.backgroundColor = colorBackground.cgColor
        view.layer.borderWidth = width
        view.layer.cornerRadius = radius
    }
    
    /// custom button circle
    func circleButton(button: UIButton) {
        button.layer.borderColor = #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = button.bounds.width / 2
    }
    
    /// custom view cell with shadow
    func customCellShadow(view: UIView) {
        view.clipsToBounds = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    /// custom imageView
    func customImageViewCell(imageView: UIImageView) {
        imageView.layer.borderColor = #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1)
        imageView.layer.borderWidth = 0.4
        imageView.layer.cornerRadius = 4
    }
    
    /// custom imageView for Icon
    func customImageViewCell(imageView: UIImageView, colorBorder: UIColor, colorBackground: UIColor, width: CGFloat, radius: CGFloat) {
        imageView.layer.borderColor = colorBorder.cgColor
        imageView.layer.backgroundColor = colorBackground.cgColor
        imageView.layer.borderWidth = width
        imageView.layer.cornerRadius = radius
    }
    
    /// custom TextView
    func customTextView(textView: UITextView, radius: CGFloat) {
        textView.layer.cornerRadius = radius
    }
}

// MARK: - Extension to manage the ActivityIndicator

extension UITableViewCell {
    
    /// manage the ActivityIndicator with UITableView
    func toggleActivityIndicator(shown: Bool, activityIndicator: UIActivityIndicatorView, imageView: UIImageView) {
        activityIndicator.isHidden = !shown
        imageView.isHidden = shown
    }
}

// MARK: - Extension to animate TableView and Cells

extension UITableViewCell {
    
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
