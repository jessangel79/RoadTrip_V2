//
//  MytripViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 13/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

final class MytripViewController: ListPlacesViewController {
    
    @IBOutlet private weak var shareBarButtonItem: UIBarButtonItem!

    // MARK: - Properties
    
    private var coreDataManager: CoreDataManager?
    private var cellSelected: PlaceEntity?
    private let segueToMyPlace = Constants.SegueToMyPlace
    
    var shareInfoTrip: String {
        var tripToShare = String()
        var index = 0
        for place in coreDataManager?.places ?? [PlaceEntity]() {
            guard let country = place.country else { return "Pays N/A" }
            guard let namePlace = place.name else { return "N/A" }
            guard let addressPlace = place.address else { return "N/A" }
            guard let typePlace = place.types else { return "N/A" }
            guard let websiteUrl = URL(string: place.website ?? "N/A") else { return "" }
            placeToShare(parameters: PlaceToShareParameters(
                country: country, namePlace: namePlace,
                addressPlace: addressPlace, typePlace: typePlace,
                websiteUrl: websiteUrl, index: index), tripToShare: &tripToShare)
            index += 1
        }
        print("tripToShare => \(tripToShare)")
        return tripToShare
    }
    
    // MARK: - Actions
    
    @IBAction private func shareBarButtonItemTapped(_ sender: UIBarButtonItem) {
        guard let places = coreDataManager?.places.isEmpty else { return }
        if places {
            presentAlert(typeError: .nothingToShare)
        } else {
            let viewController = UIActivityViewController(activityItems: [shareInfoTrip], applicationActivities: [])
            present(viewController, animated: true)
            if let popOver = viewController.popoverPresentationController {
                popOver.sourceView = self.view
                popOver.barButtonItem = shareBarButtonItem
            }
        }
    }
        
    @IBAction private func deleteMyTripBarButtonItemTapped(_ sender: UIBarButtonItem) {
        if !(coreDataManager?.places.isEmpty ?? false) {
            showAlertResetAll()
        }
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
    }
        
    // MARK: - Methods
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    private func placeToShare(parameters: PlaceToShareParameters, tripToShare: inout String) {
        var placeToShare = "🛣 Trip in \(parameters.country) 🧳 ! Hello, here is a place I want to visit : \(parameters.namePlace) to \(parameters.addressPlace) ! \n"
        placeToShare += "✨ Activities ✨ \(parameters.typePlace) ✨ \n🌐 \(parameters.websiteUrl) \n \n"
        tripToShare += "💬 Place \(parameters.index + 1) " + placeToShare
    }
    
    private func resetAll() {
        coreDataManager?.deleteAllPlaces()
        placesTableView.reloadData()
        debugCoreDataPlace(nameDebug: "All places deleted", coreDataManager: coreDataManager)
    }
    
    private func showAlertResetAll() {
        let destructiveAction = UIAlertAction(title: "Reset all", style: .destructive, handler: { action in
            self.resetAll()
        })
        showResetAlert(destructiveAction: destructiveAction)
    }
}

// MARK: - UITableViewDataSource

extension MytripViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager?.places.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listPlacesCell = tableView.dequeueReusableCell(withIdentifier: Constants.ListPlacesCell,
                                                                 for: indexPath) as? ListPlacesTableViewCell else {
            return UITableViewCell()
        }
        let place = coreDataManager?.places[indexPath.row]
        listPlacesCell.placeEntity = place
        return listPlacesCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellSelected = coreDataManager?.places[indexPath.row]
        performSegue(withIdentifier: self.segueToMyPlace, sender: self)
    }

}

// MARK: - UITableViewDelegate

extension MytripViewController {
    
    /// delete entity CoreData
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let place = coreDataManager?.places[indexPath.row]
            coreDataManager?.deletePlace(placeName: place?.name ?? "", address: place?.address ?? "")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        placesTableView.reloadData()
        debugCoreDataPlace(nameDebug: "The place is deleted", coreDataManager: coreDataManager)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Add a place in your trip"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return coreDataManager?.places.isEmpty ?? true ? 300 : 0
    }
}

// MARK: - Navigation

extension MytripViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToMyPlace {
            guard let myPlacePlaceVC = segue.destination as? MyPlaceViewController else { return }
            myPlacePlaceVC.celluleEntity = self.cellSelected
        }
    }
}
