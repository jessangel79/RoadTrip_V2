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
    @IBOutlet private weak var notesTextView: UITextView!
    @IBOutlet private weak var tripImageView: UIImageView!
    @IBOutlet private var allInfoLabels: [UILabel]!
    @IBOutlet private var allMainLabels: [UILabel]!
    @IBOutlet private var allSetLabels: [UILabel]!
    @IBOutlet private var shadowViews: [UIView]!
    @IBOutlet private weak var travellersTableView: UITableView!

    // MARK: - Properties
    
    var detailsTripEntity: DetailsTripEntity? {
        didSet {
            nameLabel.text = detailsTripEntity?.name
            setStartDateLabel.text = detailsTripEntity?.startDate
            setEndDateLabel.text = detailsTripEntity?.endDate
            setNumberDaysLabel.text = detailsTripEntity?.numberDays
            notesTextView.text = detailsTripEntity?.notes
            tripImageView.image = UIImage(named: detailsTripEntity?.imageBackground ?? Constants.ImgBackground)
            travellersNames = detailsTripEntity?.travellers?.components(separatedBy: "-") ?? [String]()
            travellersTableView.reloadData()
        }
    }
    
    var travellersNames = [String]()
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customCell()
        setTableView()
        travellersTableView.reloadData()
    }
    
    // MARK: - Methods

    private func customCell() {
        customLabelsCell(labels: allInfoLabels, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884), colorBorder: UIColor.gray)
        customLabelsCell(labels: allMainLabels, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884), colorBorder: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884))
        customLabelsCell(labels: allSetLabels, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.7516320634), colorBorder: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.7516320634))
        for view in shadowViews {
            customCellShadow(view: view)
        }
        customTextView(textView: notesTextView, radius: 10)
    }
    
    private func setTableView() {
        travellersTableView.delegate = self
        travellersTableView.dataSource = self
        travellersTableView.register(TravellerTableViewCell.nib, forCellReuseIdentifier: TravellerTableViewCell.identifier)
        travellersTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension DetailsMyTripTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travellersNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let travellersCell = tableView.dequeueReusableCell(withIdentifier: TravellerTableViewCell.identifier,
                                                                    for: indexPath) as? TravellerTableViewCell else {
            return UITableViewCell()
        }
        let travellers = travellersNames[indexPath.row]
        travellersCell.traveller = travellers
        return travellersCell
    }

}
