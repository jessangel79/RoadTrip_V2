//
//  CustomTableViewHeaderCell.swift
//  RoadTrip
//
//  Created by Angelique Babin on 25/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

class CustomTableViewHeaderCell: UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
