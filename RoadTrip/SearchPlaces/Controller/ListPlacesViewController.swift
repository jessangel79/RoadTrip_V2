//
//  ListPlacesViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 13/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

final class ListPlacesViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet private weak var placesTableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private let placeService = PlaceService()
    var placesList = [PlacesSearchElement]()
    var placesTypeList = [String]()
    var placeIDsList = [String]()
    private var cellSelected: PlacesSearchElement?
    private var placeDetailsResult: ResultDetails?
    private var placeDetailsResultsList = [ResultDetails]()
    private var photoOfCellSelected: String?
    private var imageOfCellSelected: String?
    private var placeIdCellSelected: String?
    private let segueToPlaceDetails = Constants.SegueToPlaceDetails
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: Constants.ListPlacesTableViewCell, bundle: nil)
        placesTableView.register(nib, forCellReuseIdentifier: Constants.ListPlacesCell)
        placesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        placesTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource - UITableViewDelegate

extension ListPlacesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listPlacesCell = tableView.dequeueReusableCell(withIdentifier: Constants.ListPlacesCell,
                                                                 for: indexPath) as? ListPlacesTableViewCell else {
            return UITableViewCell()
        }
        let place = placesList[indexPath.row]
        listPlacesCell.place = place
        return listPlacesCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellSelected = placesList[indexPath.row]
        self.imageOfCellSelected = placesTypeList[indexPath.row]
        self.photoOfCellSelected = urlsList.randomElement()
        performSegue(withIdentifier: self.segueToPlaceDetails, sender: self)
    }
}

// MARK: - Navigation

extension ListPlacesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToPlaceDetails {
            guard let detailsPlaceVC = segue.destination as? DetailsPlaceViewController else { return }
            detailsPlaceVC.cellule = self.cellSelected
            detailsPlaceVC.imageOfCellule = self.imageOfCellSelected
            detailsPlaceVC.photoOfCellule = self.photoOfCellSelected
        }
    }
}
