//
//  UIImageView.swift
//  RoadTrip
//
//  Created by Angelique Babin on 19/06/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

extension UIImageView {
    /// Load an image from his URL
    func load(urlImageString: String?) {
        guard let urlImageString = urlImageString else { return }
        guard let urlImage = URL(string: urlImageString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: urlImage) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                } else {
                    self?.image = UIImage(named: "bruges-maison-blanche-belgique_1024x768" + ".jpg")
                }
            }
        }
    }
}
