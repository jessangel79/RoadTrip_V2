//
//  PackingListTableViewCell.swift
//  RoadTrip
//
//  Created by Angelique Babin on 23/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

final class PackingListTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet private weak var itemLabel: UILabel!
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemCheckButton: UIButton!
    @IBOutlet private weak var categoryImageView: UIImageView!
    
    // MARK: - Properties

    private var coreDataManager: CoreDataManager?
    private var itemIsCheck = false

    // MARK: - Actions
    
    @IBAction private func itemCheckButtonTapped(_ sender: UIButton) {
        itemCheckButton.showsTouchWhenHighlighted = true
        editItemCheckButton()
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coreDataFunction()
        customCell()
    }
    
    private func customCell() {
        customLabelCell(label: itemLabel, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884), colorBorder: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884))
        customImageViewCell(imageView: categoryImageView)
        circleButton(button: itemCheckButton)
    }
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    var itemEntity: ItemEntity? {
        didSet {
            itemIsCheck = false
            itemLabel.text = itemEntity?.itemName
            itemImageView.image = UIImage(named: itemEntity?.imageBackground ?? Constants.ImgRandomBackground)
            checkIfItemIsChecked()
            categoryImageView.image = UIImage(named: itemEntity?.categoryImage ?? Constants.ImgCategoryDefault)
        }
    }
    
    private func editItemCheckButton() {
        guard let itemName = itemEntity?.itemName else { return }
        if ifCheckItemIsTrue() {
            let itemIsCheck = false
            coreDataManager?.editItemToCheckButton(itemName: itemName, itemIsCheck: itemIsCheck)
        } else {
            let itemIsCheck = true
            coreDataManager?.editItemToCheckButton(itemName: itemName, itemIsCheck: itemIsCheck)
        }
    }
    
    func setButton() {
        itemCheckButton.setImage(UIImage(named: Constants.CircleImg), for: .normal)
    }
    
    func setButtonWhenCheck() {
        itemCheckButton.setImage(UIImage(named: Constants.CheckImg), for: .normal)
    }
    
    private func ifCheckItemIsTrue() -> Bool {
        var itemIsCheck = false
        guard let itemIsCheckEntity = itemEntity?.itemIsCheck else { return false }
        if  itemIsCheckEntity {
            itemIsCheck = true
            setButton()
        } else {
            itemIsCheck = false
            setButtonWhenCheck()
        }
        return itemIsCheck
    }
    
    private func checkIfItemIsChecked() {
        guard let itemIsCheckEntity = itemEntity?.itemIsCheck else { return }
        if itemIsCheckEntity {
            setButtonWhenCheck()
        } else {
            setButton()
        }
    }
}
