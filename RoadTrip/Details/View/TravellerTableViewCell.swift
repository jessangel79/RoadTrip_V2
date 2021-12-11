//
//  TravellerTableViewCell.swift
//  RoadTrip
//
//  Created by Angelique Babin on 11/12/2021.
//  Copyright © 2021 Angelique Babin. All rights reserved.
//

import UIKit

class TravellerTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Properties
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    var traveller: String? {
        didSet {
            nameLabel.text = traveller
        }
    }
    
//    var travellerEntity: TravellerEntity? {
//        didSet {
//            nameLabel.text = travellerEntity?.name
//        }
//    }
    
    // MARK: - View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Methods
    
}
