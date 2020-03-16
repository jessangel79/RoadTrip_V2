//
//  AddDetailsMyTripViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 11/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

final class AddDetailsMyTripViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var startDateTextField: UITextField!
    @IBOutlet private weak var endDateTextField: UITextField!
    @IBOutlet private weak var travellerOneTextField: UITextField!
    @IBOutlet private weak var travellerTwoTextField: UITextField!
    @IBOutlet private weak var travellerThreeTextField: UITextField!
    @IBOutlet private weak var travellerFourTextField: UITextField!
    @IBOutlet private weak var notesTextField: UITextField!
    
    // MARK: - Properties
    
//    var detailsTrip = [DetailsTrip]()
    private var coreDataManager: CoreDataManager?

    // MARK: - Actions

    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        saveDetailsTrip()
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
        customButton(button: saveButton, radius: 20, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 1), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
        self.startDateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDoneStartDate))
        self.endDateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDoneEndDate))

    }
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    private func saveDetailsTrip() {
        guard let name = nameTextField.text, !name.isBlank else { return presentAlert(typeError: .noNameTrip)}
        guard let startDate = startDateTextField.text, !startDate.isBlank else { return presentAlert(typeError: .noStartDate) }
        guard let endDate = endDateTextField.text, !endDate.isBlank else { return presentAlert(typeError: .noEndDate)}
        guard let travellerOne = travellerOneTextField.text, !travellerOne.isBlank else { return presentAlert(typeError: .noTraveller)}
        guard let travellerTwo = travellerTwoTextField.text else { return }
        guard let travellerThree = travellerThreeTextField.text else { return }
        guard let travellerFour = travellerFourTextField.text  else { return }
        guard let notes = notesTextField.text else { return }
        
        let startDateFromString = startDate.toDate()
        let endDateFromString = endDate.toDate()
        
        if endDateFromString < startDateFromString {
            presentAlert(typeError: .errorDate)
        } else {
            let numberDays = endDateFromString.timeSinceDateInDays(fromDate: startDateFromString)

            coreDataManager?.createDetailsTrip(parameters: DetailsTrip(name: name.capitalized, startDate: startDate,
                                                                       endDate: endDate, numberDays: numberDays,
                                                                       travellerOne: travellerOne.localizedCapitalized,
                                                                       travellerTwo: travellerTwo.localizedCapitalized,
                                                                       travellerThree: travellerThree.localizedCapitalized,
                                                                       travellerFour: travellerFour.localizedCapitalized, notes: notes))
            cleanTextField()
            resignFirstResponderTextField()
            navigationController?.popViewController(animated: true)

            debugCoreDataDetailsTrip(nameDebug: "Details trip saved", coreDataManager: coreDataManager)
        }

    }
        
    private func cleanTextField() {
        nameTextField.text = String()
        startDateTextField.text = String()
        endDateTextField.text = String()
        travellerOneTextField.text = String()
        travellerTwoTextField.text = String()
        travellerThreeTextField.text = String()
        travellerFourTextField.text = String()
        notesTextField.text = String()
    }
    
    private func resignFirstResponderTextField() {
        nameTextField.resignFirstResponder()
        startDateTextField.resignFirstResponder()
        endDateTextField.resignFirstResponder()
        travellerOneTextField.resignFirstResponder()
        travellerTwoTextField.resignFirstResponder()
        travellerThreeTextField.resignFirstResponder()
        travellerFourTextField.resignFirstResponder()
        notesTextField.resignFirstResponder()
    }
    
}

// MARK: - DatePicker

extension AddDetailsMyTripViewController {
    
    @objc func tapDoneStartDate() {
        if let datePicker = self.startDateTextField.inputView as? UIDatePicker {
            self.startDateTextField.text = setSelectedDate(datePicker: datePicker)
        }
        self.startDateTextField.resignFirstResponder()
    }
    
    @objc func tapDoneEndDate() {
        if let datePicker = self.endDateTextField.inputView as? UIDatePicker {
            self.endDateTextField.text = setSelectedDate(datePicker: datePicker)
         }
        self.endDateTextField.resignFirstResponder()
    }
    
    private func setSelectedDate(datePicker: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.dateStyle = .short
        let selectedDate = dateFormatter.string(from: datePicker.date)
        print("Selected value \(selectedDate)")
        return selectedDate
    }
}

// MARK: - Keyboard

extension AddDetailsMyTripViewController: UITextFieldDelegate {
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        resignFirstResponderTextField()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveDetailsTrip()
        return true
    }
}

// MARK: - Navigation

// MARK: - Extension
