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
    func customLabelsCell(labels: [UILabel]) {
        for label in labels {
            label.layer.cornerRadius = 5
            label.layer.backgroundColor = #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884)
            label.layer.borderColor = UIColor.gray.cgColor
            label.layer.borderWidth = 1.0
        }
    }
    
    /// custom view
    func customViewCell(view: UIView) {
        view.layer.cornerRadius = 5
        view.layer.backgroundColor = #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884)
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1.0
    }
}
