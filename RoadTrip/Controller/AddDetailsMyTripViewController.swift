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
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var tripImageView: UIImageView!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var startDateTextField: UITextField!
    @IBOutlet private weak var endDateTextField: UITextField!
    @IBOutlet private weak var travellerOneTextField: UITextField!
    @IBOutlet private weak var travellerTwoTextField: UITextField!
    @IBOutlet private weak var travellerThreeTextField: UITextField!
    @IBOutlet private weak var travellerFourTextField: UITextField!
    @IBOutlet private weak var notesTextField: UITextField!
    @IBOutlet private var allLabels: [UILabel]!
    
    // MARK: - Properties
    
    private var coreDataManager: CoreDataManager?
    private var startDateString = String()
    private var endDateString = String()
    private var tripExist = false
    var cellule: DetailsTripEntity?
    var celluleActive = false
    var celluleIndex = 0
    private var randomImage = String()
    
    // MARK: - Actions

    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        saveDetailsTrip()
        textFieldResignFirstResponder()
    }
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
        customButton(button: saveButton, radius: 20, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 1), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
        customAllLabels(allLabels: allLabels, radius: 5, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5))
                
        self.startDateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDoneStartDate))
        self.endDateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDoneEndDate))
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        checkIfCelluleActive()
    }
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    private func saveDetailsTrip() {
        guard let name = nameTextField.text, !name.isBlank else { return presentAlert(typeError: .noNameTrip) }
        guard let startDate = startDateTextField.text, !startDate.isBlank else { return presentAlert(typeError: .noStartDate) }
        guard let endDate = endDateTextField.text, !endDate.isBlank else { return presentAlert(typeError: .noEndDate)}
        guard let travellerOne = travellerOneTextField.text, !travellerOne.isBlank else { return presentAlert(typeError: .noTraveller)}
        guard let travellerTwo = travellerTwoTextField.text else { return }
        guard let travellerThree = travellerThreeTextField.text else { return }
        guard let travellerFour = travellerFourTextField.text  else { return }
        guard let notes = notesTextField.text else { return }
        startDateString = startDate
        endDateString = endDate
        let numberDays = calculateDays()
        
        if checkIfDateCorrect() {
            if !checkIfNameTripExist(name: name) {
                if !celluleActive {
                    coreDataManager?.createDetailsTrip(parameters: DetailsTrip(name: name,
                                                                               startDate: startDate,
                                                                               endDate: endDate,
                                                                               numberDays: numberDays,
                                                                               travellerOne: travellerOne,
                                                                               travellerTwo: travellerTwo,
                                                                               travellerThree: travellerThree,
                                                                               travellerFour: travellerFour,
                                                                               notes: notes, imageBackground: randomImage))
                    navigationController?.popViewController(animated: true)
                    debugCoreDataDetailsTrip(nameDebug: "Details trip saved", coreDataManager: coreDataManager)
                } else {
//                    nameTextField.isUserInteractionEnabled = false
//                    nameTextField.isEnabled = false
//                    nameTextField.allowsEditingTextAttributes = false
//                    let image = cellule?.imageBackground ?? "iles-de-locean_1024x1024.png"
                    guard let image = cellule?.imageBackground else { return }
                    coreDataManager?.editDetailsTrip(parameters: DetailsTrip(name: name,
                                                                             startDate: startDate,
                                                                             endDate: endDate,
                                                                             numberDays: numberDays,
                                                                             travellerOne: travellerOne,
                                                                             travellerTwo: travellerTwo,
                                                                             travellerThree: travellerThree,
                                                                             travellerFour: travellerFour,
                                                                             notes: notes, imageBackground: image), index: celluleIndex)
                    navigationController?.popViewController(animated: true)
                    debugCoreDataDetailsTrip(nameDebug: "Details trip changed", coreDataManager: coreDataManager)
                }
            }
        }
    }
    
    private func checkIfNameTripExist(name: String) -> Bool {
//        guard let checkIfNameTripExist = coreDataManager?.checkIfNameTripExist(nameTrip: name.localizedCapitalized) else { return false }
        let checkIfNameTripExist = coreDataManager?.checkIfNameTripExist(nameTrip: name.localizedCapitalized) ?? false
        tripExist = checkIfNameTripExist
        if tripExist && name == cellule?.name?.localizedCapitalized {
            return false
        } else if tripExist {
            presentAlert(typeError: .nameExist)
            return true
        }
        return false
    }
    
    private func checkIfDateCorrect() -> Bool {
        let startDateFromString = startDateString.toDate()
        let endDateFromString = endDateString.toDate()
        if endDateFromString < startDateFromString {
            presentAlert(typeError: .errorDate)
            return false
        }
        return true
    }
    
    private func calculateDays() -> String {
        let startDateFromString = startDateString.toDate()
        let endDateFromString = endDateString.toDate()
        return endDateFromString.timeSinceDateInDays(fromDate: startDateFromString)
    }
        
    private func checkIfCelluleActive() {
        if celluleActive {
            displayTrip()
        } else {
            randomImage = imagesBackgroundList.shuffled().randomElement() ?? "iles-de-locean_1024x1024.png"
            tripImageView.image = UIImage(named: randomImage)
            cleanTextField()
        }
        print("viewDidload celluleActive : \(celluleActive)")
        print("viewDidload celluleIndex : \(celluleIndex)")
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
    
    private func displayTrip() {
        nameTextField.text = cellule?.name
        startDateTextField.text = cellule?.startDate
        endDateTextField.text = cellule?.endDate
        travellerOneTextField.text = cellule?.travellerOne
        travellerTwoTextField.text = cellule?.travellerTwo
        travellerThreeTextField.text = cellule?.travellerThree
        travellerFourTextField.text = cellule?.travellerFour
        notesTextField.text = cellule?.notes
        tripImageView.image = UIImage(named: cellule?.imageBackground ?? "iles-de-locean_1024x1024.png")
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
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.dateStyle = .short
        let selectedDate = dateFormatter.string(from: datePicker.date)
        print("Selected value \(selectedDate)")
        return selectedDate
    }
}

// MARK: - Keyboard

extension AddDetailsMyTripViewController: UITextFieldDelegate {
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textFieldResignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveDetailsTrip()
        textField.resignFirstResponder()
//        textFieldResignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
      // reset back the content inset to zero after keyboard is gone
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
    }
    
    private func textFieldResignFirstResponder() {
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
