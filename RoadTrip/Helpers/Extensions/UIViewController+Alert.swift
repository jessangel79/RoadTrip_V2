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
        case noItem
        case noTrip
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
        case .noItem:
            title = "No item"
            message = "Please to set an item."
        case .noTrip:
            title = "No trip created"
            message = "Please create at least one trip in details tab to select a traveller."
        }
        
        alertError(title, message)
    }
    
    /// Enumeration of the error
    enum AlertErrorExist {
        case nameExist
        case nothingToShare
        case itemExist
        case travellerNameExist
        case travellerNotExist
        case listIsEmpty
        case impossibleToDeleteTraveler
        case impossibleToDeleteTravelersList
    }
    
    /// Alert message for user
    func presentAlert(typeError: AlertErrorExist) {
        var message: String
        var title: String
        
        switch typeError {
        case .nameExist:
            title = "This name of trip already exist"
            message = "Please to set another name for you trip."
        case .nothingToShare:
            title = "Nothing to share"
            message = "Sorry there is nothing to share."
        case .itemExist:
            title = "This item already exist"
            message = "Please to set another item."
        case .travellerNameExist:
            title = "This name already exist"
            message = "Please to set another name."
        case .travellerNotExist:
            title = "No traveler with this name."
            message = "Please to set another name."
        case .listIsEmpty:
            title = "No item for this traveler"
            message = ""
        case .impossibleToDeleteTraveler:
            title = "Warning impossible to delete this traveler !"
            message = """
    Cannot delete this traveler because there is a packing list for him.
    Please delete the packing list of this traveler before performing this deletion.
    """
        case .impossibleToDeleteTravelersList:
            title = "Warning impossible to delete these travelers !"
            message = """
    Cannot delete these travelers because there is a packing list for at less the one of them.
    Please delete the packing lists of these travelers before performing this deletion.
    """
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
    private func showAlert(_ destructiveAction: UIAlertAction, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(destructiveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    /// Enumeration of the error
    enum AlertShowAction {
        case resetAllAlert
        case deletedTripAlert
//        case deleteTravelerAlertIfPackingListIsEmpty
//        case deleteTravelerAlertIfPackingListIsNotEmpty
    }
    
    /// Alert message with action for user
    func showAlertWithAction(_ destructiveAction: UIAlertAction, typeError: AlertShowAction) {
        var message: String
        var title: String
        
        switch typeError {
        case .resetAllAlert:
            title =  "Warning Reset All !"
            message = "Are you sure to reset all ?"
        case .deletedTripAlert:
            title = "Warning delete of this trip !"
            message = """
Impossible to delete this trip! There is a packing list for at least one of the travelers on this trip.

"""
//Are you sure you want to delete this trip ? This will also erase the packing list of the travelers present on this trip.
//If you want to keep your items you must classify them in \"uncategorized\" in the suitcase before carrying out this deletion.

//        case .deleteTravelerAlertIfPackingListIsEmpty:
//            title = "Warning delete of this traveler !"
//            message = "Are you sure you want to delete this traveler ?"
//        case .deleteTravelerAlertIfPackingListIsNotEmpty:
//            title = "Warning impossible to delete this traveler !"
//            message = """
//Cannot delete this traveler because there is a packing list for him.
//Please delete the packing list of this traveler before performing this deletion.
//"""
        }
        showAlert(destructiveAction, title: title, message: message)
    }
    
    /// Display an alert to enter the traveller name
    func displayAddTravellerAlert(handlerAddTravellerName: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "Add new traveler", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Traveler"
            textField.autocapitalizationType = .words
        }
        let action = UIAlertAction(title: "Add", style: .default, handler: { _ in
            guard let textField = alertController.textFields else { return }
            handlerAddTravellerName(textField[0].text)
        })
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    /// Display an alert to delete the list of a traveller
    func displayDeleteListTravellerAlert(handlerDeleteListByTravellerName: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "Set the name of traveler", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Traveler"
            textField.autocapitalizationType = .words
        }
        let deleteAction = UIAlertAction(title: "Delete list for this traveler ?", style: .destructive, handler: { _ in
            guard let textField = alertController.textFields else { return }
            handlerDeleteListByTravellerName(textField[0].text)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
