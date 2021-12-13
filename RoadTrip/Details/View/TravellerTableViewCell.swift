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
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var baseView: UIView!
    
    // MARK: - Properties
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    var traveller: String? {
        didSet {
            nameLabel.text = traveller
        }
    }

    // MARK: - View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        customCellShadow(view: baseView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
