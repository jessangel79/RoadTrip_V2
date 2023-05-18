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
    @IBOutlet private weak var travellerTextField: UITextField!
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var categoryPickerView: UIPickerView!
    
    // MARK: - Properties
    
    private var itemExist = false
    var travellersNames = [String]()
    private var travellerChoicePickerView = UIPickerView()
    var celluleItem: ItemEntity?
    var celluleItemActive = false
    var celluleItemIndex: Int?
    var celluleItemSection: Int?
    
    // MARK: - Actions

    @IBAction override func saveButtonTapped(_ sender: UIButton) {
        saveItem()
        print("coreDataManager?.items in saveButtonTapped")
        print(coreDataManager?.items as Any)
        itemTextField.resignFirstResponder()
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
//        adMobService.setAdMob(bannerView, self)
        adColonyService.destroyAd()
        adColonyService.requestBannerAd(Constants.AdColony.Banner1, self) // 1
        coreDataFunction()
        customUI()
        setImagebackground()
        setTravellerPickerView()
        setTravellerTextField()
        setPickerViewsRowsSelected()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfCelluleActive()
    }
    
    // MARK: - Methods

    override func customUI() {
        customButton(button: saveButton, radius: 20, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 1), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
    }
    
    private func saveItem() {
        guard let itemName = itemTextField.text?.trimWhitespaces, !itemName.isBlank else { return presentAlert(typeError: .noItem) }
        guard let traveller = travellerTextField.text?.trimWhitespaces, !traveller.isBlank else { return presentAlert(typeError: .noTraveller) }
        let categoryIndex = categoryPickerView.selectedRow(inComponent: 0)
        let category = categoriesList[categoryIndex]
        if !checkIfItemExistByTraveller(item: itemName, traveller: traveller, category: category) {
            saveItemWithCheckIfCelluleActive(itemName, traveller, category)
        }
    }
    
    private func checkIfItemExistByTraveller(item: String, traveller: String, category: String) -> Bool {
        let checkIfItemExist = coreDataManager?.checkIfItemExistByTraveller(itemName: item.localizedCapitalized, traveller: traveller.localizedCapitalized) ?? false
        itemExist = checkIfItemExist
        if itemExist && category == celluleItem?.category {
            presentAlert(typeError: .itemExist)
            return true
        }
        return false
    }
    
    private func saveItemWithCheckIfCelluleActive(_ itemName: String, _ traveller: String, _ category: String) {
        if !celluleItemActive {
            coreDataManager?.createItem(Item(itemName: itemName,
                                             traveller: traveller,
                                             category: category,
                                             itemIsCheck: false,
                                             categoryImage: category.deleteWhitespaces.lowercased(),
                                             imageBackground: randomImage))
        } else {
            let image = celluleItem?.imageBackground ?? Constants.ImgBackground
            coreDataManager?.editItem(Item(itemName: itemName,
                                           traveller: traveller,
                                           category: category,
                                           itemIsCheck: celluleItem?.itemIsCheck ?? false,
                                           categoryImage: category.deleteWhitespaces.lowercased(),
                                           imageBackground: image), itemName: itemName, traveller: traveller, id: celluleItem?.id ?? UUID())
            
        }
        performSegue(withIdentifier: Constants.SegueToPackingList, sender: self)
    }
    
    private func setImagebackground() {
        randomImage = imagesBackgroundList.shuffled().randomElement() ?? Constants.ImgRandomBackground
        itemImageView.image = UIImage(named: randomImage)
        itemTextField.text = String()
    }
    
    private func setTravellerPickerView() {
        travellerTextField.delegate = self
        travellerChoicePickerView.delegate = self
        travellerChoicePickerView.dataSource = self
        travellerChoicePickerView.tag = 1
    }
    
    private func setTravellerTextField() {
        if travellersNames.count == 1 {
            travellerTextField.inputView = travellerChoicePickerView
            presentAlert(typeError: .noTrip)
        } else {
            travellerTextField.inputView = travellerChoicePickerView
        }
    }
    
    private func setPickerViewsRowsSelected() {
        if celluleItemActive {
            setPickerViewRow(rowSelected: celluleItem?.category, list: categoriesList, pickerview: categoryPickerView)
            setPickerViewRow(rowSelected: celluleItem?.traveller, list: travellersNames, pickerview: travellerChoicePickerView)
        } else {
            categoryPickerView.reloadAllComponents()
            travellerChoicePickerView.reloadAllComponents()
        }
    }
    
    private func setPickerViewRow(rowSelected: String?, list: [String], pickerview: UIPickerView) {
        guard let rowSelected = rowSelected else { return }
        if let row = list.firstIndex(of: rowSelected) {
            pickerview.selectRow(row, inComponent: 0, animated: false)
        }
    }

    private func checkIfCelluleActive() {
        if celluleItemActive {
            displayItem()
        } else {
            cleanTextField()
        }
    }
    
    private func displayItem() {
        itemTextField.text = celluleItem?.itemName
        travellerTextField.text = celluleItem?.traveller
        itemImageView.image = UIImage(named: celluleItem?.imageBackground ?? Constants.ImgBackground)
    }
    
    private func cleanTextField() {
        itemTextField.text = String()
        travellerTextField.inputView = travellerChoicePickerView
    }
    
}

// MARK: - PickerView

extension AddItemViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countRows = Int()
        if pickerView.tag == 0 {
            countRows = categoriesList.count
        } else if pickerView.tag == 1 {
            countRows = travellersNames.count
        }
        return countRows
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var titleForRow = String()
        if pickerView.tag == 0 {
            titleForRow = categoriesList[row]
        } else if pickerView.tag == 1 {
            titleForRow = travellersNames[row]
        }
        return titleForRow
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            travellerTextField.text = travellersNames[row]
            travellerTextField.resignFirstResponder()
        }
    }
}

// MARK: - Keyboard

extension AddItemViewController {
    
    @IBAction override func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        itemTextField.resignFirstResponder()
        travellerTextField.resignFirstResponder()
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveItem()
        textField.resignFirstResponder()
        return true
    }
}
