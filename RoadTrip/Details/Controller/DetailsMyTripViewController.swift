//
//  DetailsMyTripViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 11/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

import GoogleMobileAds

class DetailsMyTripViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var myTripTableView: UITableView! {
        didSet { myTripTableView.tableFooterView = UIView() }
    }
    
    @IBOutlet weak var bannerView: GADBannerView!

    // MARK: - Properties
    
    var coreDataManager: CoreDataManager?
    private var cellSelected: DetailsTripEntity?
    private let segueToAddDetails = Constants.SegueToAddDetails
    var celluleActive = false
    var celluleIndex = 0
    var tabType = Constants.Trip
    
    let adMobService = AdMobService()
    
    // MARK: - Actions
    
    @IBAction func resetBarButtonItemTapped(_ sender: UIBarButtonItem) {
        if !(coreDataManager?.detailsTrips.isEmpty ?? false) {
            showAlertResetAll()
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adMobService.setAdMob(bannerView, self)
        coreDataFunction()
        setNib()
        animationTableView(tableView: myTripTableView)
        myTripTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        celluleActive = false
        myTripTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Methods
    
    func setNib() {
        let nib = UINib(nibName: Constants.DetailsMyTripTableViewCell, bundle: nil)
        myTripTableView.register(nib, forCellReuseIdentifier: Constants.DetailsMyTripCell)
    }

    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    func resetAll() {
        coreDataManager?.deleteAllDetailsTrip()
        animationTableView(tableView: myTripTableView)
        myTripTableView.reloadData()
    }
    
    func showAlertResetAll() {
        let destructiveAction = UIAlertAction(title: "Reset all", style: .destructive, handler: { action in
            self.resetAll()
        })
        showAlertWithAction(destructiveAction, typeError: .resetAllAlert)
    }
    
//    private func checkIfTravelerExistInAnotherTrip(_ indexPath: IndexPath) -> Bool {
//        guard let detailsTrips = coreDataManager?.detailsTrips else { return false }
//        var travellersList = [String]()
//        for detailsTrip in detailsTrips {
//            guard let travellers = detailsTrip.travellers?.components(separatedBy: "-") else { return false }
//            travellersList += travellers
//        }
//        let detailsTripSelected = self.coreDataManager?.detailsTrips[indexPath.row]
//        guard let travellersSelected = detailsTripSelected?.travellers?.components(separatedBy: "-") else { return false }
//
//        let countsItemDict = travellersList.histogram
//        let keysOfCountsItemDict = countsItemDict.allKeys(forValue: 2)
//
//        var travelerExistInAnotherTrip = false
//        if keysOfCountsItemDict.count == travellersSelected.count {
//            travelerExistInAnotherTrip = true
//        } else {
//            travelerExistInAnotherTrip = false
//        }
//
//        return travelerExistInAnotherTrip
//    }
    
    private func destructionTrip(_ indexPath: IndexPath, _ tableView: UITableView) {
        let destructiveAction = UIAlertAction(title: "Yes, I want to delete this trip.", style: .destructive, handler: { action in
            let detailsTrip = self.coreDataManager?.detailsTrips[indexPath.row]
            guard let travellers = detailsTrip?.travellers?.components(separatedBy: "-") else { return }
            for traveller in travellers {
                self.coreDataManager?.deleteItemsByTraveller(traveller: traveller)
            }
            self.coreDataManager?.deleteDetailsTrip(nameTrip: detailsTrip?.name ?? "")
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.myTripTableView.reloadData()
            self.animationCell(tableView)
        })
        showAlertWithAction(destructiveAction, typeError: .deletedTripAlert)
    }
    
}

// MARK: - UITableViewDataSource

extension DetailsMyTripViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager?.detailsTrips.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailsMyTripCell = tableView.dequeueReusableCell(withIdentifier: Constants.DetailsMyTripCell,
                                                                    for: indexPath) as? DetailsMyTripTableViewCell else {
            return UITableViewCell()
        }
        let detailsTrip = coreDataManager?.detailsTrips[indexPath.row]
        detailsMyTripCell.detailsTripEntity = detailsTrip
        return detailsMyTripCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellSelected = coreDataManager?.detailsTrips[indexPath.row]
        celluleActive = true
        celluleIndex = indexPath.row
        performSegue(withIdentifier: self.segueToAddDetails, sender: self)
    }
}

// MARK: - UITableViewDelegate

extension DetailsMyTripViewController: UITableViewDelegate {

    /// delete entity CoreData
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let checkIfTravelerExistInAnotherTrip = coreDataManager?.checkIfTravelerExistInAnotherTrip(indexPath) ?? false
            if checkIfTravelerExistInAnotherTrip {
                destructionTrip(indexPath, tableView)
            } else {
                let detailsTrip = self.coreDataManager?.detailsTrips[indexPath.row]
                self.coreDataManager?.deleteDetailsTrip(nameTrip: detailsTrip?.name ?? "")
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.myTripTableView.reloadData()
                self.animationCell(tableView)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Click on ➕ to add a \(tabType)"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return coreDataManager?.detailsTrips.isEmpty ?? true ? 300 : 0
    }
}

// MARK: - Navigation

extension DetailsMyTripViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToAddDetails {
            guard let addDetailsMyTripVC = segue.destination as? AddDetailsMyTripViewController else { return }
            addDetailsMyTripVC.cellule = self.cellSelected
            if celluleActive {
                addDetailsMyTripVC.celluleActive = true
                addDetailsMyTripVC.celluleIndex = celluleIndex
            } else {
                addDetailsMyTripVC.celluleActive = false
            }
        }
    }
}
