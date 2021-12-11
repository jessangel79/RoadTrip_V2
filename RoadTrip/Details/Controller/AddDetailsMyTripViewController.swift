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
//    @IBOutlet private weak var travellerOneTextField: UITextField!
//    @IBOutlet private weak var travellerTwoTextField: UITextField!
//    @IBOutlet private weak var travellerThreeTextField: UITextField!
//    @IBOutlet private weak var travellerFourTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet private var allLabels: [UILabel]!
    @IBOutlet private weak var travellersTableView: UITableView! {
        didSet { travellersTableView.tableFooterView = UIView() }
    }
    
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
//    private var cellSelected: TravellerEntity?
//    private var travellers: TravellerEntity?
    var travellersNames = [String]()

    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveDetailsTrip()
        textFieldResignFirstResponder()
    }
    
    @IBAction func addTravellerBarButtonItemTapped(_ sender: UIBarButtonItem) {
        displayAddTravellerAlert { [weak self] travellerName in
            guard let travellerName = travellerName?.trimWhitespaces, !travellerName.isBlank else { return } // self?.presentAlert(typeError: .noTraveller)
            self?.travellersNames.append(travellerName)
//            self?.coreDataManager?.createTraveller(travellerName)
            self?.travellersTableView.reloadData()
        }
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
        setTableView()
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
    
    private func setTableView() {
        travellersTableView.delegate = self
        travellersTableView.dataSource = self
        travellersTableView.register(TravellerTableViewCell.nib, forCellReuseIdentifier: TravellerTableViewCell.identifier)
        travellersTableView.reloadData()
    }
    
    private func saveDetailsTrip() {
        guard let name = nameTextField.text?.trimWhitespaces, !name.isBlank else {
            return presentAlert(typeError: .noNameTrip)
        }
        guard let startDate = startDateTextField.text, !startDate.isBlank else { return presentAlert(typeError: .noStartDate) }
        guard let endDate = endDateTextField.text, !endDate.isBlank else { return presentAlert(typeError: .noEndDate)}
//        guard let travellerOne = travellerOneTextField.text?.trimWhitespaces, !travellerOne.isBlank else {
//            return presentAlert(typeError: .noTraveller)
//        }
//        guard let travellerTwo = travellerTwoTextField.text?.trimWhitespaces else { return }
//        guard let travellerThree = travellerThreeTextField.text?.trimWhitespaces else { return }
//        guard let travellerFour = travellerFourTextField.text?.trimWhitespaces  else { return }
        
//        guard let travellers = coreDataManager?.travellers else { return }
//        for traveller in travellers {
//            travellersNames.append(traveller.name ?? "")
//        }
        guard let notesTextView = notesTextView.text?.trimWhitespaces else { return }
        
        startDateString = startDate
        endDateString = endDate
        let numberDays = calculateDays()
        let travellersNamesString = travellersNames.joined(separator: "-")

        if checkIfDateCorrect() {
            if !checkIfNameTripExist(name: name) {
                if !celluleActive {
                    coreDataManager?.createTraveller(travellersNamesString)
                    coreDataManager?.createDetailsTrip(parameters: DetailsTrip(name: name,
                                                                               startDate: startDate,
                                                                               endDate: endDate,
                                                                               numberDays: numberDays,
                                                                               travellers: travellersNamesString,
//                                                                               travellerOne: travellerOne,
//                                                                               travellerTwo: travellerTwo,
//                                                                               travellerThree: travellerThree,
//                                                                               travellerFour: travellerFour,
                                                                               notes: notesTextView, imageBackground: randomImage))
                    navigationController?.popViewController(animated: true)
                } else {
                    let image = cellule?.imageBackground ?? Constants.ImgBackground
                    coreDataManager?.createTraveller(travellersNamesString)
                    coreDataManager?.editDetailsTrip(parameters: DetailsTrip(name: name,
                                                                             startDate: startDate,
                                                                             endDate: endDate,
                                                                             numberDays: numberDays,
                                                                             travellers: travellersNamesString,
//                                                                             travellerOne: travellerOne,
//                                                                             travellerTwo: travellerTwo,
//                                                                             travellerThree: travellerThree,
//                                                                             travellerFour: travellerFour,
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
        
//        travellersNames.removeAll()
//        travellersTableView.reloadData()
        
//        travellerOneTextField.text = String()
//        travellerTwoTextField.text = String()
//        travellerThreeTextField.text = String()
//        travellerFourTextField.text = String()
        notesTextView.text = String()
    }
    
    private func displayTrip() {
        nameTextField.text = cellule?.name
        startDateTextField.text = cellule?.startDate
        endDateTextField.text = cellule?.endDate
//        travellerOneTextField.text = cellule?.travellerOne
//        travellerTwoTextField.text = cellule?.travellerTwo
//        travellerThreeTextField.text = cellule?.travellerThree
//        travellerFourTextField.text = cellule?.travellerFour

        travellersNames = cellule?.travellers?.components(separatedBy: "-") ?? [String]()
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
//        travellerOneTextField.resignFirstResponder()
//        travellerTwoTextField.resignFirstResponder()
//        travellerThreeTextField.resignFirstResponder()
//        travellerFourTextField.resignFirstResponder()
        notesTextView.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource

extension AddDetailsMyTripViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travellersNames.count
//        return coreDataManager?.travellers.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let travellersCell = tableView.dequeueReusableCell(withIdentifier: TravellerTableViewCell.identifier,
                                                                    for: indexPath) as? TravellerTableViewCell else {
            return UITableViewCell()
        }
//        let travellers = coreDataManager?.travellers[indexPath.row]
        let travellers = travellersNames[indexPath.row]
        travellersCell.traveller = travellers
        return travellersCell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.cellSelected = coreDataManager?.detailsTrips[indexPath.row]
//        celluleActive = true
//        celluleIndex = indexPath.row
//        performSegue(withIdentifier: self.segueToAddDetails, sender: self)
//    }
}

// MARK: - UITableViewDelegate

extension AddDetailsMyTripViewController: UITableViewDelegate {
    
    /// delete entity CoreData
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let traveller = coreDataManager?.travellers[indexPath.row]
            coreDataManager?.deleteTraveller(traveller?.name ?? "")
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        travellersTableView.reloadData()
        animationCell(tableView)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Click on 👤 to add a traveller"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return travellersNames.isEmpty ? 100 : 0
//        return coreDataManager?.travellers.isEmpty ?? true ? 100 : 0
    }
}
