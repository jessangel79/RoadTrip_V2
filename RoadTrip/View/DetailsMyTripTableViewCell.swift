//
//  DetailsMyTripTableViewCell.swift
//  RoadTrip
//
//  Created by Angelique Babin on 11/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

class DetailsMyTripTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var setStartDateLabel: UILabel!
    @IBOutlet weak var setEndDateLabel: UILabel!
    @IBOutlet weak var setNumberDaysLabel: UILabel!
    @IBOutlet weak var travellerOneLabel: UILabel!
    @IBOutlet weak var travellerTwoLabel: UILabel!
    @IBOutlet weak var travellerThreeLabel: UILabel!
    @IBOutlet weak var travellerFourLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    // MARK: - Methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
   var detailsTripEntity: DetailsTripEntity? {
        didSet {
            nameLabel.text = detailsTripEntity?.name
            setStartDateLabel.text = detailsTripEntity?.startDate
            setEndDateLabel.text = detailsTripEntity?.endDate
            setNumberDaysLabel.text = detailsTripEntity?.numberDays
            travellerOneLabel.text = detailsTripEntity?.travellerOne
            travellerTwoLabel.text = detailsTripEntity?.travellerTwo
            travellerThreeLabel.text = detailsTripEntity?.travellerThree
            travellerFourLabel.text = detailsTripEntity?.travellerFour
            notesTextView.text = detailsTripEntity?.notes
            
//            startDateLabel.text = "Start date of trip :"
//            endDateLabel.text = "End date of trip :"
//            numberDaysLabel.text = "Number of days :"
//            print("photoReference in place => \(photo)")
//            print("listPlacesCell.placeImageView.image in listTVCell => \(String(describing: placeImageView.image)))")
        }
    }

}
