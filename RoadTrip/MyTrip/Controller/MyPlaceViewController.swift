//
//  MyPlaceViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 19/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import SDWebImage

final class MyPlaceViewController: DetailsPlaceViewController {
        
    // MARK: - Properties

    var celluleEntity: PlaceEntity?

    override var shareInfoPlace: String {
        guard let country = celluleEntity?.country else { return "Pays N/A" }
        guard let types = celluleEntity?.types else { return "N/A" }
        guard let websiteUrl = URL(string: celluleEntity?.website ?? "N/A") else { return "" }
        return placeToShare(country, placeName, address, types, websiteUrl)
    }

    // MARK: - Actions
    
    @IBAction override func websiteButtonTapped(_ sender: UIButton) {
        if let websiteUrl = celluleEntity?.website {
            if websiteUrl == "N/A" {
                presentAlert(typeError: .noWebsite)
            } else {
                openSafari(websiteUrl)
            }
        }
    }

    @IBAction override func saveBarButtonItemTapped(_ sender: UIBarButtonItem) {
        checkIfPlaceIsSaved()
        deletePlace()
        navigationController?.popViewController(animated: true)

    }

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfPlaceIsSaved()
    }
    
    override func viewWillAppear(_ animated: Bool) {}
    
    // MARK: - Methods
    
    override func setCelluleData() {
        placeName = celluleEntity?.name ?? ""
        address = celluleEntity?.address ?? ""
        guard let phoneNumber = celluleEntity?.phoneNumber else { return }
        let openHours = setOpeningHours(openingHours: celluleEntity?.openDays)
        let informations = celluleEntity?.informations ?? ""
        let types = (celluleEntity?.types ?? "")
        let rating = celluleEntity?.rating ?? ""
        let icon = celluleEntity?.icon ?? ""
        let country = celluleEntity?.country ?? ""
        let website = celluleEntity?.website ?? ""
        let photo = celluleEntity?.photo ?? ""
        let lat = celluleEntity?.lat ?? ""
        let lon = celluleEntity?.lon ?? ""

        configurePlace(parameters: PlaceParameters(
            address: address, country: country, icon: icon,
            name: placeName, openDays: openHours, phoneNumber: phoneNumber,
            photo: photo, rating: rating, types: types,
            website: website, informations: informations, lat: lat, lon: lon))
    }
}

// MARK: - Navigation

extension MyPlaceViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToMap {
            guard let mapOfMyPlaceVC = segue.destination as? MapOfMyPlaceViewController else { return }
            mapOfMyPlaceVC.celluleEntity = self.celluleEntity
        }
    }
}
