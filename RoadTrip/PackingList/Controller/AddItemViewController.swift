//
//  AddItemViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 24/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

final class AddItemViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var itemTextField: UITextField!
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var categoryPickerView: UIPickerView!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: - Properties
    
    private var coreDataManager: CoreDataManager?
    private var randomImage = String()
    private var itemExist = false
    
    // MARK: - Actions
    
    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        saveItem()
        itemTextField.resignFirstResponder()
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
        customButton(button: saveButton, radius: 20, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.7516320634), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
        setImagebackground()
    }
    
    // MARK: - Methods
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
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
            debugCoreDataItem(nameDebug: "Item saved", coreDataManager: coreDataManager)
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
        randomImage = imagesBackgroundList.shuffled().randomElement() ?? "piha-beach-nouvelle-zelande_1024x1024.jpg"
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

extension AddItemViewController: UITextFieldDelegate {
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        itemTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveItem()
        textField.resignFirstResponder()
        return true
    }
}
