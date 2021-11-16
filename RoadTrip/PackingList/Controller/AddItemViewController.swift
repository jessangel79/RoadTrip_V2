//
//  AddItemViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 24/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

final class AddItemViewController: AddDetailsMyTripViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var itemTextField: UITextField!
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var categoryPickerView: UIPickerView!
    
    // MARK: - Properties
    
    private var itemExist = false
    
    // MARK: - Actions
    
    @IBAction override func saveButtonTapped(_ sender: UIButton) {
        saveItem()
        itemTextField.resignFirstResponder()
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        adMobService.setAdMob(bannerView, self)
        coreDataFunction()
        customUI()
        setImagebackground()
    }
    
    override func viewWillAppear(_ animated: Bool) { }
    
    // MARK: - Methods

    override func customUI() {
        customButton(button: saveButton, radius: 20, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 1), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
    }
    
    private func saveItem() {
        guard let itemName = itemTextField.text?.trimWhitespaces, !itemName.isBlank else { return presentAlert(typeError: .noItem) }
        let categoryIndex = categoryPickerView.selectedRow(inComponent: 0)
        let category = categoriesList[categoryIndex]
        if !checkIfItemExist(item: itemName) {
            coreDataManager?.createItem(itemName: itemName, imageBackground: randomImage,
                                        category: category, itemIsCheck: false,
                                        categoryImage: category.deleteWhitespaces.lowercased())
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func checkIfItemExist(item: String) -> Bool {
        let checkIfItemExist = coreDataManager?.checkIfItemExist(itemName: item.localizedCapitalized) ?? false
        itemExist = checkIfItemExist
        if itemExist {
            presentAlert(typeError: .itemExist)
            return true
        }
        return false
    }
    
    private func setImagebackground() {
        randomImage = imagesBackgroundList.shuffled().randomElement() ?? Constants.ImgRandomBackground
        itemImageView.image = UIImage(named: randomImage)
        itemTextField.text = String()
    }
}

// MARK: - PickerView

extension AddItemViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesList[row]
    }
}

// MARK: - Keyboard

extension AddItemViewController {
    
    @IBAction override func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        itemTextField.resignFirstResponder()
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveItem()
        textField.resignFirstResponder()
        return true
    }
}
