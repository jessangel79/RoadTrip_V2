//
//  AddDetailsMyTripViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 11/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

import GoogleMobileAds

class AddDetailsMyTripViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var tripImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var startDateTextField: UITextField!
    @IBOutlet private weak var endDateTextField: UITextField!
    @IBOutlet private weak var travellerOneTextField: UITextField!
    @IBOutlet private weak var travellerTwoTextField: UITextField!
    @IBOutlet private weak var travellerThreeTextField: UITextField!
    @IBOutlet private weak var travellerFourTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet private var allLabels: [UILabel]!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    // MARK: - Properties
    
    var coreDataManager: CoreDataManager?
    private var startDateString = String()
    private var endDateString = String()
    private var tripExist = false
    var cellule: DetailsTripEntity?
    var celluleActive = false
    var celluleIndex: Int?
    var randomImage = String()
    
    let adMobService = AdMobService()
        
    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveDetailsTrip()
        textFieldResignFirstResponder()
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.delegate = self
        adMobService.setAdMob(bannerView, self)
        coreDataFunction()
        customUI()
        setDatePicker()
        keyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfCelluleActive()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Methods

    func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    func customUI() {
        customButton(button: saveButton, radius: 20, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 1), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
        customAllLabels(allLabels: allLabels, radius: 5, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5))
    }
    
    private func setDatePicker() {
        self.startDateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDoneStartDate))
        self.endDateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDoneEndDate))
    }
    
    private func keyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func saveDetailsTrip() {
        guard let name = nameTextField.text?.trimWhitespaces, !name.isBlank else {
            return presentAlert(typeError: .noNameTrip)
        }
        guard let startDate = startDateTextField.text, !startDate.isBlank else { return presentAlert(typeError: .noStartDate) }
        guard let endDate = endDateTextField.text, !endDate.isBlank else { return presentAlert(typeError: .noEndDate)}
        guard let travellerOne = travellerOneTextField.text?.trimWhitespaces, !travellerOne.isBlank else {
            return presentAlert(typeError: .noTraveller)
        }
        guard let travellerTwo = travellerTwoTextField.text?.trimWhitespaces else { return }
        guard let travellerThree = travellerThreeTextField.text?.trimWhitespaces else { return }
        guard let travellerFour = travellerFourTextField.text?.trimWhitespaces  else { return }
        guard let notesTextView = notesTextView.text?.trimWhitespaces else { return }
        
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
                                                                               notes: notesTextView, imageBackground: randomImage))
                    navigationController?.popViewController(animated: true)
                } else {
                    let image = cellule?.imageBackground ?? Constants.ImgBackground
                    coreDataManager?.editDetailsTrip(parameters: DetailsTrip(name: name,
                                                                             startDate: startDate,
                                                                             endDate: endDate,
                                                                             numberDays: numberDays,
                                                                             travellerOne: travellerOne,
                                                                             travellerTwo: travellerTwo,
                                                                             travellerThree: travellerThree,
                                                                             travellerFour: travellerFour,
                                                                             notes: notesTextView, imageBackground: image), index: celluleIndex ?? 0)
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func checkIfNameTripExist(name: String) -> Bool {
        let checkIfNameTripExist = coreDataManager?.checkIfNameTripExist(nameTrip: name) ?? false
        tripExist = checkIfNameTripExist
        if tripExist && celluleActive == true && name == cellule?.name {
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
            randomImage = imagesBackgroundList.shuffled().randomElement() ?? Constants.ImgBackground
            tripImageView.image = UIImage(named: randomImage)
            cleanTextField()
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
        notesTextView.text = String()
    }
    
    private func displayTrip() {
        nameTextField.text = cellule?.name
        startDateTextField.text = cellule?.startDate
        endDateTextField.text = cellule?.endDate
        travellerOneTextField.text = cellule?.travellerOne
        travellerTwoTextField.text = cellule?.travellerTwo
        travellerThreeTextField.text = cellule?.travellerThree
        travellerFourTextField.text = cellule?.travellerFour
        notesTextView.text = cellule?.notes
        tripImageView.image = UIImage(named: cellule?.imageBackground ?? Constants.ImgBackground)
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
//        print("Selected value \(selectedDate)")
        return selectedDate
    }
}

// MARK: - Keyboard

extension AddDetailsMyTripViewController: UITextFieldDelegate, UITextViewDelegate {
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textFieldResignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
    }

    /// reset back the content inset to zero after keyboard is gone
    @objc func keyboardWillHide(notification: NSNotification) {
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
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
        notesTextView.resignFirstResponder()
    }
}
