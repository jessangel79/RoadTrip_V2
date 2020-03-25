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
    func customViewCell(view: UIView) {
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1.0
        view.layer.backgroundColor = #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884)
        view.layer.borderColor = UIColor.gray.cgColor
    }
}
