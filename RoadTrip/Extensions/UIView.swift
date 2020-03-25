//
//  UIView.swift
//  RoadTrip
//
//  Created by Angelique Babin on 25/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

extension UIView {

    // incredibly useful:

    func bindEdgesToSuperview() {

        guard let superview = superview else {
            preconditionFailure("`superview` nil in bindEdgesToSuperview")
        }

        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
}
