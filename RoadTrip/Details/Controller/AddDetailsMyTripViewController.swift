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
    @IBOutlet private weak var notesTextView: UITextView!
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
    private var travellersNames = [String]()
    private var cellSelected: String?

    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveDetailsTrip()
        textFieldResignFirstResponder()
    }
    
    @IBAction func addTravellerBarButtonItemTapped(_ sender: UIBarButtonItem) {
        displayAddTravellerAlert { [unowned self] travellerName in
            guard let travellerName = travellerName?.trimWhitespaces, !travellerName.isBlank else { return }
            if travellersNames.contains(travellerName.capitalized) {
                presentAlert(typeError: .travellerNameExist)
            } else {
                self.travellersNames.append(travellerName.capitalized)
            }
            self.travellersTableView.reloadData()
        }
    }
    
    @IBAction func removeTravellersListBarButtonItemTapped(_ sender: UIBarButtonItem) {
        travellersNames.removeAll()
        travellersTableView.reloadData()
        // TODO: coredata maj
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
        customTableView(tableView: travellersTableView, radius: 10, width: 0.8, colorBorder: .gray)
        customTextView(textView: notesTextView, radius: 10)
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
        guard let notesTextView = notesTextView.text?.trimWhitespaces else { return }
        let travellersNamesJoined = travellersNames.joined(separator: "-")
        startDateString = startDate
        endDateString = endDate
        let numberDays = calculateDays()
        if checkIfDateCorrect() {
            if !checkIfNameTripExist(name: name) {
                if checkIfOneTraveller() {
                    saveDetailsTripWithCheckIfCelluleActive(travellersNamesJoined, name, startDate, endDate, numberDays, notesTextView)
                }
            }
        }
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
    
    private func checkIfOneTraveller() -> Bool {
        if travellersNames.isEmpty {
            presentAlert(typeError: .noTraveller)
            return false
        }
        return true
    }
    
    private func saveDetailsTripWithCheckIfCelluleActive(_ travellersNamesJoined: String, _ name: String, _ startDate: String, _ endDate: String, _ numberDays: String, _ notesTextView: String) {
        if !celluleActive {
            coreDataManager?.createTraveller(travellersNamesJoined)
            coreDataManager?.createDetailsTrip(
                DetailsTrip(name: name, startDate: startDate,
                            endDate: endDate, numberDays: numberDays,
                            travellers: travellersNamesJoined,
                            notes: notesTextView,
                            imageBackground: randomImage))
        } else {
            let image = cellule?.imageBackground ?? Constants.ImgBackground
            coreDataManager?.editTraveller(travellersNamesJoined, index: celluleIndex ?? 0)
            coreDataManager?.editDetailsTrip(
                DetailsTrip(name: name, startDate: startDate,
                            endDate: endDate, numberDays: numberDays,
                            travellers: travellersNamesJoined,
                            notes: notesTextView,
                            imageBackground: image), index: celluleIndex ?? 0)
        }
        navigationController?.popViewController(animated: true)
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
    
    private func displayTrip() {
        nameTextField.text = cellule?.name
        startDateTextField.text = cellule?.startDate
        endDateTextField.text = cellule?.endDate
        travellersNames = cellule?.travellers?.components(separatedBy: "-") ?? [String]()
        notesTextView.text = cellule?.notes
        tripImageView.image = UIImage(named: cellule?.imageBackground ?? Constants.ImgBackground)
    }
    
    private func cleanTextField() {
        nameTextField.text = String()
        startDateTextField.text = String()
        endDateTextField.text = String()
        notesTextView.text = String()
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
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let travellersCell = tableView.dequeueReusableCell(withIdentifier: TravellerTableViewCell.identifier,
                                                                    for: indexPath) as? TravellerTableViewCell else {
            return UITableViewCell()
        }
        let travellers = travellersNames[indexPath.row]
        travellersCell.traveller = travellers
        return travellersCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellSelected = travellersNames[indexPath.row]
        guard let cellSelected = cellSelected else { return }
        displayEditTravellerAlert(cellSelected: cellSelected) { [unowned self] cellSelected in
            guard let cellSelected = cellSelected?.trimWhitespaces, !cellSelected.isBlank else { return }
            
            // TODO: alert to user !!! coredata maj
            
            self.travellersNames.remove(at: indexPath.row)
            self.travellersNames.insert(cellSelected.capitalized, at: indexPath.row)
            self.travellersTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate

extension AddDetailsMyTripViewController: UITableViewDelegate {
    
    /// delete entity CoreData
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            travellersNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            // TODO: alert to user !!! coredata MAJ
        }
        travellersTableView.reloadData()
        animationCell(tableView)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Click on 👤 to add a traveler"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1)
        customLabel(label: label, radius: 10, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5))
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return travellersNames.isEmpty ? 44 : 0
    }
}
