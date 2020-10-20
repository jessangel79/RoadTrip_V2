//
//  UITextField.swift
//  RoadTrip
//
//  Created by Angelique Babin on 16/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

extension UITextField {
    
    /// Create a UIDatePicker object and create a toolbar to set date
    func setInputViewDatePicker(target: Any, selector: Selector) {
        
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone.autoupdatingCurrent
        
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        
        self.inputView = datePicker

        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .done, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }

    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
