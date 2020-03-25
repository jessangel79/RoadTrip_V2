//
//  MytripViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 13/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

final class MytripViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet private weak var myTripTableView: UITableView! {
        didSet { myTripTableView.tableFooterView = UIView() }
    }
    
    @IBOutlet private weak var shareBarButtonItem: UIBarButtonItem!

    // MARK: - Properties
    
    private var coreDataManager: CoreDataManager?
    private var cellSelected: PlaceEntity?
    private let segueToMyPlace = Constants.SegueToMyPlace
    
    var shareInfoPlace: String {
        var tripToShare = String()
        var index = 0
        for place in coreDataManager?.places ?? [PlaceEntity]() {
            guard let namePlace = place.name else { return "" }
            guard let addressPlace = place.address else { return "" }
            guard let country = place.country else { return "" }
            guard let typePlace = place.types?.changeDash.capitalized else { return "" }
            guard let websiteUrl = URL(string: place.website ?? "") else { return "" }
            guard let mapUrl = URL(string: place.url ?? "") else { return "" }
            var placeToShare = "🛣 Trip in \(country) 🧳 ! Hello, here is a place I want to visit : \(namePlace) to \(addressPlace) ! \n"
                   placeToShare += "✨ Activities ✨ \(typePlace). \n🌐 \(websiteUrl) \n🗺 \(mapUrl) \n \n"
            tripToShare += "💬 Place \(index + 1) " + placeToShare
            index += 1
        }
        print("tripToShare \(tripToShare)")
        return tripToShare
    }
    
    // MARK: - Actions
    
    @IBAction func shareBarButtonItemTapped(_ sender: UIBarButtonItem) {
        guard let places = coreDataManager?.places.isEmpty else { return }
        if places {
            presentAlert(typeError: .nothingToShare)
        } else {
            let viewController = UIActivityViewController(activityItems: [shareInfoPlace], applicationActivities: [])
            present(viewController, animated: true)
            if let popOver = viewController.popoverPresentationController {
                popOver.sourceView = self.view
                popOver.barButtonItem = shareBarButtonItem
            }
        }
    }
        
    @IBAction func deleteMyTripBarButtonItemTapped(_ sender: UIBarButtonItem) {
        coreDataManager?.deleteAllPlaces()
        myTripTableView.reloadData()
        debugCoreDataPlace(nameDebug: "All places deleted", coreDataManager: coreDataManager)
    }

    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myTripTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
        let nib = UINib(nibName: Constants.ListPlacesTableViewCell, bundle: nil)
        myTripTableView.register(nib, forCellReuseIdentifier: Constants.ListPlacesCell)
        myTripTableView.reloadData()
    }
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
}

// MARK: - UITableViewDataSource

extension MytripViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager?.places.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listPlacesCell = tableView.dequeueReusableCell(withIdentifier: Constants.ListPlacesCell,
                                                                 for: indexPath) as? ListPlacesTableViewCell else {
            return UITableViewCell()
        }
        let place = coreDataManager?.places[indexPath.row]
        listPlacesCell.placeEntity = place
        return listPlacesCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellSelected = coreDataManager?.places[indexPath.row]
        performSegue(withIdentifier: self.segueToMyPlace, sender: self)
    }

}

// MARK: - UITableViewDelegate

extension MytripViewController: UITableViewDelegate {
    
    /// delete entity CoreData
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let place = coreDataManager?.places[indexPath.row]
            coreDataManager?.deletePlace(placeName: place?.name ?? "", address: place?.address ?? "")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        myTripTableView.reloadData()
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
            myPlacePlaceVC.cellule = self.cellSelected
        }
    }
}
