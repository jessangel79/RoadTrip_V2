//
//  UIViewController+Alert.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

// MARK: - Extension to display a alert message to the user

extension UIViewController {
    /// Enumeration of the error
    enum AlertError {
        case isEmpty
        case noPlace
        case noWebsite
        case noDetail
        case zeroResult
        case errorAccess
        case noNameTrip
        case noTraveller
        case noStartDate
        case noEndDate
        case errorDate
    }

    /// Alert message to user
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
            message = "Sorry there is no website for this place"
        case .noDetail:
            title = "No detail"
            message = "Sorry there is no detail for this place."
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
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
