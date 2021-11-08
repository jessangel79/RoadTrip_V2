//
//  ListPlacesViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 13/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

import GoogleMobileAds

class ListPlacesViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var placesTableView: UITableView! {
        didSet { placesTableView.tableFooterView = UIView() }
    }
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    // MARK: - Properties
    
    var placesList = [PlacesSearchElement]()
    private var cellSelected: PlacesSearchElement?
    private var photoOfCellSelected: String?
    private let segueToPlaceDetails = Constants.SegueToPlaceDetails
    
    let adMobService = AdMobService()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adMobService.setAdMob(bannerView, self)
        
        let nib = UINib(nibName: Constants.ListPlacesTableViewCell, bundle: nil)
        placesTableView.register(nib, forCellReuseIdentifier: Constants.ListPlacesCell)
        animationTableView(tableView: placesTableView)
        placesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        placesTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adMobService.loadBannerAd(bannerView)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.adMobService.loadBannerAd(self.bannerView)
        })
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
            detailsPlaceVC.photoOfCellule = self.photoOfCellSelected
        }
    }
}
