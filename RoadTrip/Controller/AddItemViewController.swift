//
//  AddItemViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 24/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    // MARK: - Properties
    
    private var coreDataManager: CoreDataManager?
    private var randomImage = String()
    private var itemExist = false
//    var cellule: ItemEntity?
    
    // MARK: - Actions
    
    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        saveItem()
        itemTextField.resignFirstResponder()
    }

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
        setImagebackground()
    }
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    private func saveItem() {
        guard let itemName = itemTextField.text, !itemName.isBlank else { return presentAlert(typeError: .noItem) }
        let categoryIndex = categoryPickerView.selectedRow(inComponent: 0)
        let category = categoriesList[categoryIndex]
        if !checkIfItemExist(item: itemName) {
            coreDataManager?.createItem(itemName: itemName, imageBackground: randomImage, category: category)
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
