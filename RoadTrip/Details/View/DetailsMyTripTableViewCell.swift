//
//  DetailsMyTripTableViewCell.swift
//  RoadTrip
//
//  Created by Angelique Babin on 11/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

final class DetailsMyTripTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var setStartDateLabel: UILabel!
    @IBOutlet private weak var setEndDateLabel: UILabel!
    @IBOutlet private weak var setNumberDaysLabel: UILabel!
    @IBOutlet private weak var travellerOneLabel: UILabel!
    @IBOutlet private weak var travellerTwoLabel: UILabel!
    @IBOutlet private weak var travellerThreeLabel: UILabel!
    @IBOutlet private weak var travellerFourLabel: UILabel!
    @IBOutlet private weak var notesTextView: UITextView!
    @IBOutlet private weak var tripImageView: UIImageView!
    @IBOutlet private var allInfoLabels: [UILabel]!
    @IBOutlet private var allMainLabels: [UILabel]!
    @IBOutlet private var allSetLabels: [UILabel]!
    
    // MARK: - Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        customCell()
    }
    
    private func customCell() {
        customLabelsCell(labels: allInfoLabels, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884), colorBorder: UIColor.gray)
        customLabelsCell(labels: allMainLabels, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884), colorBorder: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884))
        customLabelsCell(labels: allSetLabels, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.7516320634), colorBorder: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.7516320634))
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
            tripImageView.image = UIImage(named: detailsTripEntity?.imageBackground ?? "iles-de-locean_1024x1024.png")
        }
    }
}
