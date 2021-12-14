//
//  UIViewController+Alert.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

// MARK: - Extension to display an alert message to the user

extension UIViewController {
    
    /// Enumeration of the error
    enum AlertError {
        case isEmpty
        case noPlace
        case noWebsite
        case zeroResult
        case errorAccess
        case noNameTrip
        case noTraveller
        case noStartDate
        case noEndDate
        case errorDate
        case nameExist
        case nothingToShare
        case noItem
        case itemExist
        case travellerNameExist
        case noTripSelected
    }
    
    /// Alert message for user
    func presentAlert(typeError: AlertError) {
        var message: String
        var title: String
      
        switch typeError {
        case .isEmpty:
            title = "No city or place"
            message = "Please to set a city and a place."
        case .noPlace:
            title = "No place"
            message = "Sorry there is no place."
        case .noWebsite:
            title = "No website"
            message = "Sorry there is no website for this place."
        case .zeroResult:
            title = "No result"
            message = "Sorry there is no result."
        case .errorAccess:
            title = "Error Acces"
            message = "Sorry there is an error to access the calendar."
        case .noNameTrip:
            title = "No name for the trip"
            message = "Please to set a name for the trip."
        case .noTraveller:
            title = "No traveller"
            message = "Please to set a traveller."
        case .noStartDate:
            title = "No start date"
            message = "Please to set a start date."
        case .noEndDate:
            title = "No end date"
            message = "Please to set an end date."
        case .errorDate:
            title = "Error date"
            message = "Please to set correct start and end dates."
        case .nameExist:
            title = "This name of trip already exist"
            message = "Please to set another name for you trip."
        case .nothingToShare:
            title = "Nothing to share"
            message = "Sorry there is nothing to share."
        case .noItem:
            title = "No item"
            message = "Please to set an item."
        case .itemExist:
            title = "This item already exist"
            message = "Please to set another item."
        case .travellerNameExist:
            title = "This name already exist"
            message = "Please to set another name."
        case .noTripSelected:
            title = "Selected your Trip"
            message = "Please to selected your trip to choose a traveller."
        }
        
        alertError(title, message)
    }
    
    /// Base of alert for custom action
    private func alertCustomAction(_ title: String, _ message: String, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func alertError(_ title: String, _ message: String) {
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertCustomAction(title, message, action: action)
    }
    
    func presentAlertMapInfo(_ title: String, _ message: String) {
        let action = UIAlertAction(title: "OK", style: .default)
        alertCustomAction(title, message, action: action)
    }
    
    /// Alert message for user to confirm all reset
    func showResetAlert(destructiveAction: UIAlertAction) {
        let alert = UIAlertController(title: "Warning Reset All", message: "Are you sure to reset all ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(destructiveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    /// Display an alert to enter the traveller name
    func displayAddTravellerAlert(handlerAddTravellerName: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "Add new traveller", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Traveller"
        }
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { _ in
            guard let textField = alertController.textFields else { return }
            handlerAddTravellerName(textField[0].text)
        })
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// Display an alert to rename the traveller
    func displayEditTravellerAlert(cellSelected: String, handlerAddTravellerName: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "Rename the traveller", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = cellSelected
        }
        let addAction = UIAlertAction(title: "Rename", style: .default, handler: { _ in
            guard let textField = alertController.textFields else { return }
            handlerAddTravellerName(textField[0].text)
        })
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func displayChooseTravellersAlert(viewController: UIViewController) {
        let alertController = UIAlertController(title: "Choose the traveller", message: "", preferredStyle: .actionSheet)
        
//        let vc = UIViewController()
//        vc.preferredContentSize = CGSize(width: 250,height: 300)
//        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
//        pickerView.delegate = self
//        pickerView.dataSource = self
//        vc.view.addSubview(pickerView)
//        let editRadiusAlert = UIAlertController(title: "Choose the traveller", message: "", preferredStyle: .alert)
//        editRadiusAlert.setValue(vc, forKey: "contentViewController")
//        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
//        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(editRadiusAlert, animated: true)
        
//        let action = UIAlertAction(title: "Select", style: .default) { _ in
//
//        }
//        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
    
//    func displayPickerViewAlert() {
//        let alert = UIAlertController(title: "Choose the traveller", message: "Which traveler do you want to do the packing list ?", preferredStyle: .actionSheet)
//
//        let frameSizes: [CGFloat] = (150...400).map { CGFloat($0) }
//        let pickerViewValues: [[String]] = [frameSizes.map { Int($0).description }]
//        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: frameSizes.index(of: 216) ?? 0)
//
//        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
//            DispatchQueue.main.async {
//                UIView.animate(withDuration: 1) {
//                    vc.preferredContentSize.height = frameSizes[index.row]
//                }
//            }
//        }
//        alert.addAction(title: "Done", style: .cancel)
//        alert.show()
//    }
}
