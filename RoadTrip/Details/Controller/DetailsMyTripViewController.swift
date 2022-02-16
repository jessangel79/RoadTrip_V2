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
//        showResetAllAlert(destructiveAction)
        showAlertWithAction(destructiveAction, typeError: .resetAllAlert)
    }
    
    // TODO: KO - checkIfTravelerExistInAnotherTrip
//    private func checkIfTravelerExistInAnotherTrip(_ indexPath: IndexPath, _ tableView: UITableView) -> Bool {
//        var travelerExistInAnotherTrip = false
//        guard let detailsTrips = coreDataManager?.detailsTrips else { return false }
//        let detailsTripSelected = self.coreDataManager?.detailsTrips[indexPath.row]
//        guard let travellersSelected = detailsTripSelected?.travellers?.components(separatedBy: "-") else { return false }
//
//        for detailsTrip in detailsTrips {
//            guard let travellers = detailsTrip.travellers?.components(separatedBy: "-") else { return false }
//            for traveller in travellers {
//                var travellersInTrip = [String]()
//                if traveller == travellersSelected[indexPath.row] {
//                    travellersInTrip.append(traveller)
//                    travelerExistInAnotherTrip = true
//                }
//                print("travellersInTrip")
//                print(travellersInTrip)
//            }
//        }
//        return travelerExistInAnotherTrip
//    }
    
    private func destructionTrip(_ indexPath: IndexPath, _ tableView: UITableView) {
//        let items = coreDataManager?.items
//        guard let items = items else { return }
//        let itemsByTraveler = getItemsList(items: items, index: indexPath.row)
        
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
//        showDeletedTripAlert(destructiveAction: destructiveAction)
    }
    
//    private func getItemTraveller() {
//        itemTraveller.removeAll()
//        let items = coreDataManager?.items
//        guard let items = items else { return }
//        if !travellersNames.isEmpty {
//            for index in 0...travellersNames.count-1 {
//                itemTraveller.append(ItemTraveller(travellerName: travellersNames[index], items: getItemsList(items: items, index: index)))
//            }
//        }
//    }
    
//    private func getItemsList(items: [ItemEntity], index: Int) -> [ItemEntity] {
//        var itemsList = [ItemEntity]()
//        for item in items where item.traveller == travellersNames[index] {
//            itemsList.append(item)
//        }
//        print(itemsList)
//        return itemsList
//    }
    
//    private func getTravellersNames() {
//        trips = coreDataManager?.detailsTrips
//        guard let trips = trips else { return }
//        if !trips.isEmpty {
//            for trip in trips {
//                travellersNames.append(contentsOf: trip.travellers?.components(separatedBy: "-") ?? ["Uncategorized"])
//            }
//            travellersNames = travellersNames.removingDuplicates
//            travellersNames = travellersNames.sorted()
//        }
//    }
    
//    private func checkIfListIsNotEmpty(_ travellerName: String) -> Bool {
//        var listIsNotEmpty = false
//        for traveller in self.itemTraveller where traveller.travellerName == travellerName {
//            guard let items = traveller.items else { return false }
//            if !items.isEmpty {
//                listIsNotEmpty = true
//            }
//        }
//        return listIsNotEmpty
//    }
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
            // TODO: TEST
//            checkIfTravelerExistInAnotherTrip(indexPath, tableView)
//            if checkIfTravelerExistInAnotherTrip(indexPath, tableView) {
//                destructionTrip(indexPath, tableView)
//            } else {
//                let detailsTrip = self.coreDataManager?.detailsTrips[indexPath.row]
//                self.coreDataManager?.deleteDetailsTrip(nameTrip: detailsTrip?.name ?? "")
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//                self.myTripTableView.reloadData()
//                self.animationCell(tableView)
//            }
            destructionTrip(indexPath, tableView)
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
