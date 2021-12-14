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
    @IBOutlet private weak var travellerTextField: UITextField!
    @IBOutlet private weak var tripPickerViewButton: UIButton!
    @IBOutlet private weak var tripNameLabel: UILabel!
    
    // MARK: - Properties
    
    private var itemExist = false
    private var travellersNames = [String]()
    private var trips: [DetailsTripEntity]?
    private var tripNames = [String]()
    private var travellerChoicePickerView = UIPickerView()
    private var tripName = String()
    private let screenWidth = UIScreen.main.bounds.width - 10
    private let screenHeight = UIScreen.main.bounds.height / 2
    private var selectedRow = 0
    
    // MARK: - Actions
    
    @IBAction private func tripButtonTapped(_ sender: UIButton) {
        selectTrip()
//        if travellersNames.isEmpty {
//            presentAlert(typeError: .noTripSelected)
//        } else {
//            travellerTextField.inputView = travellerChoicePickerView
//        }
    }
    
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
 
        travellerTextField.delegate = self
        
        trips = coreDataManager?.detailsTrips
        guard let trips = trips else { return }
        for trip in trips {
            tripNames.append(trip.name ?? "")
        }
        
        print(trips as Any)
        print(tripNames)

        travellerChoicePickerView.delegate = self
        travellerChoicePickerView.dataSource = self
        travellerChoicePickerView.tag = 2
        
        if trips.isEmpty {
            presentAlert(typeError: .noTripSelected)
//            navigationController?.popViewController(animated: true)
        } else {
            selectTrip()
        }

        travellerTextField.inputView = travellerChoicePickerView

//        if !travellersNames.isEmpty {
//            travellerTextField.inputView = travellerChoicePickerView
//        }
        
//        if travellersNames.isEmpty {
//            presentAlert(typeError: .noTripSelected)
//        } else {
//            travellerTextField.inputView = travellerChoicePickerView
//        }
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
    
    private func selectTrip() {
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.tag = 1
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        viewController.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select your trip", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = tripPickerViewButton
        alert.popoverPresentationController?.sourceRect = tripPickerViewButton.bounds
        
        alert.setValue(viewController, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            let selectedName = self.tripNames[self.selectedRow]
            self.tripNameLabel.text = selectedName
            guard let trips = self.trips else { return }
            for trip in trips where trip.name == selectedName {
                let travellersNamesJoined = trip.travellers
                self.travellersNames = travellersNamesJoined?.components(separatedBy: "-") ?? [String]()
            }
        }))
        self.present(alert, animated: true, completion: nil)
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
            countRows = tripNames.count
        } else if pickerView.tag == 2 {
            countRows = travellersNames.count
        }
        return countRows
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var titleForRow = String()
        if pickerView.tag == 0 {
            titleForRow = categoriesList[row]
        } else if pickerView.tag == 1 {
            titleForRow = tripNames[row]
        } else if pickerView.tag == 2 {
            titleForRow = travellersNames[row]
        }
        return titleForRow
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 2 {
            travellerTextField.text = travellersNames[row]
            travellerTextField.resignFirstResponder()
        }
    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
//        if pickerView.tag == 1 {
//            label.text = tripNames[row]
//            label.sizeToFit()
//        }
//        return label
//    }
    
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        var rowHeight = CGFloat()
//        if pickerView.tag == 1 {
//            rowHeight = 60
//        }
//        return rowHeight
//    }
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
