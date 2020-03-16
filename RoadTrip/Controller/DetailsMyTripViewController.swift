//
//  DetailsMyTripViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 11/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

final class DetailsMyTripViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet private weak var detailsMyTripTableView: UITableView! {
        didSet { detailsMyTripTableView.tableFooterView = UIView() }
    }
    
    // MARK: - Properties
//    private var detailsMyTripList = [DetailsTrip]()
    private var coreDataManager: CoreDataManager?
    private var cellSelected: DetailsTripEntity?
//    private let segueToMyTrip = Constants.SegueToMyTrip

    // MARK: - Actions

    @IBAction private func resetBarButtonItemTapped(_ sender: UIBarButtonItem) {
        coreDataManager?.deleteAllDetailsTrip()
        detailsMyTripTableView.reloadData()
        debugCoreDataDetailsTrip(nameDebug: "All details trip deleted", coreDataManager: coreDataManager)
    }
    
    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailsMyTripTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
//        detailsMyTripList += ["test", "retour"]
        
        let nib = UINib(nibName: Constants.DetailsMyTripTableViewCell, bundle: nil)
        detailsMyTripTableView.register(nib, forCellReuseIdentifier: Constants.DetailsMyTripCell)

        detailsMyTripTableView.reloadData()
    }
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }

}

// MARK: - UITableViewDataSource

extension DetailsMyTripViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager?.detailsTrip.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailsMyTripCell = tableView.dequeueReusableCell(withIdentifier: Constants.DetailsMyTripCell,
                                                                    for: indexPath) as? DetailsMyTripTableViewCell else {
            return UITableViewCell()
        }
        let detailsTrip = coreDataManager?.detailsTrip[indexPath.row]
        detailsMyTripCell.detailsTripEntity = detailsTrip
        return detailsMyTripCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.cellSelected = placesList[indexPath.row]
//        self.photoOfCellSelected = photosList[indexPath.row]
//        self.placeIdCellSelected = placeIDsList[indexPath.row]
//        performSegue(withIdentifier: self.segueToPlaceDetails, sender: self)
    }
}

// MARK: - UITableViewDelegate

extension DetailsMyTripViewController: UITableViewDelegate {
    
    /// delete entity CoreData
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let detailsTrip = coreDataManager?.detailsTrip[indexPath.row]
            coreDataManager?.deleteDetailsTrip(nameTrip: detailsTrip?.name ?? "",
                                               startDate: detailsTrip?.startDate ?? "",
                                               endDate: detailsTrip?.endDate ?? "")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        detailsMyTripTableView.reloadData()
        debugCoreDataPlace(nameDebug: "The trip is deleted", coreDataManager: coreDataManager)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Click on ➕ to add a trip"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return coreDataManager?.detailsTrip.isEmpty ?? true ? 300 : 0
    }
}

// MARK: - Navigation

extension DetailsMyTripViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == segueToMyPlace {
//            guard let myPlacePlaceVC = segue.destination as? MyPlaceViewController else { return }
//            myPlacePlaceVC.cellule = self.cellSelected
//        }
//    }
}

// MARK: - Extension
