//
//  PackingListTableViewCell.swift
//  RoadTrip
//
//  Created by Angelique Babin on 23/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

class PackingListTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    // MARK: - Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        customLabelCell(label: itemLabel, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884), colorBorder: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884))
    }
    
   var itemEntity: ItemEntity? {
        didSet {
            itemLabel.text = itemEntity?.itemName
            itemImageView.image = UIImage(named: itemEntity?.imageBackground ?? "piha-beach-nouvelle-zelande_1024x1024.jpg")
        }
    }
}
