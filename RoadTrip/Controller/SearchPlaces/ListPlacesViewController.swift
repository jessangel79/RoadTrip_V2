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
//    var placesList = [Result]()
//    var photosList = [String]()
    var placesTypeList = [String]()
    var placeIDsList = [String]()
    private var cellSelected: PlacesSearchElement?
//    private var cellSelected: Result?
    private var placeDetailsResult: ResultDetails?
    private var placeDetailsResultsList = [ResultDetails]()
    private var photoOfCellSelected: String?
    private var imageOfCellSelected: String?
    private var placeIdCellSelected: String?
    private let segueToPlaceDetails = Constants.SegueToPlaceDetails
    private var celluleIndex = 0

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: Constants.ListPlacesTableViewCell, bundle: nil)
        placesTableView.register(nib, forCellReuseIdentifier: Constants.ListPlacesCell)
        
//        for placeId in placeIDsList {
//            getPlaceDetails(placeId: placeId)
//        }
//        createImagesArray()
//        print("array images : \(imagesArray)")
        imagesArray = [UIImage]()
        placesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        imagesArray = [UIImage]()

//        placesTableView.reloadData()
    }
    
    fileprivate func createImagesArray() {
        let placeType = placesList.first?.type ?? "default"
        loadImages(urlImageString: "https://source.unsplash.com/800x600/?\(placeType)")
        print("images array : \(imagesArray)")
    }
    
    func loadImages(urlImageString: String?) {
        let imageView = UIImageView()
        guard let urlImageString = urlImageString else { return }
        guard let urlImage = URL(string: urlImageString) else { return }
        DispatchQueue.global().async { [weak imageView] in
            if let data = try? Data(contentsOf: urlImage) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView?.image = image
                    }
                } else {
                    imageView?.image = UIImage(named: "bruges-maison-blanche-belgique_1024x768" + ".jpg")
                }
            }
        }
        for _ in 1...20 {
            guard let imageViewImage = imageView.image else { return }
            imagesArray.append(imageViewImage)
        }
        print("images array in load test: \(imagesArray)")
    }
    
    // OK mais pas dans cell
//    private func getPhotos(_ placeType: String?, placeImageView: UIImageView) {
//        let placeholderImage = UIImage(named: "bruges-maison-blanche-belgique_1024x768.jpg")
//        guard let placeType = placeType else { return }
////        guard let url = URL(string: place ?? "") else { return }
//        let stringUrl = "https://source.unsplash.com/800x600/?\(placeType)"
////        print("url getPhotos : \(url)")
//        print("url getPhotos : \(stringUrl)")
//
////        toggleActivityIndicator(shown: true, activityIndicator: activityIndicator, imageView: placeImageView)
//        DispatchQueue.main.async {
////            self.toggleActivityIndicator(shown: false, activityIndicator: self.activityIndicator, imageView: self.placeImageView)
//            placeImageView.sd_setImage(with: URL(string: stringUrl), placeholderImage: placeholderImage)
//        }
//    }
    
//    private func getPlaceDetails(placeId: String) {
//        toggleActivityIndicator(shown: true, activityIndicator: activityIndicator, tableview: placesTableView)
//        placeService.getPlaceDetails(placeId: placeId) { (success, placeDetails) in
//            self.toggleActivityIndicator(shown: false,
//                                    activityIndicator: self.activityIndicator,
//                                    tableview: self.placesTableView)
//            if success {
//                if placeDetails?.status == "OK" {
//                    guard let placeDetails = placeDetails else { return }
//                    self.placeDetailsResult = placeDetails.result
//                    guard let placeDetailsResult = self.placeDetailsResult else { return }
//                    self.placeDetailsResultsList.append(placeDetailsResult)
//                } else {
//                    print("No result")
//                    self.toggleActivityIndicator(shown: false,
//                                                 activityIndicator: self.activityIndicator,
//                                                 tableview: self.placesTableView)
//                }
//            } else {
//                print("No detail")
//                self.toggleActivityIndicator(shown: false,
//                                             activityIndicator: self.activityIndicator,
//                                             tableview: self.placesTableView)
//            }
//        }
//    }
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
//        getPhotos(place.type, placeImageView: listPlacesCell.placeImageView)
        listPlacesCell.place = place
        return listPlacesCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellSelected = placesList[indexPath.row]
        self.imageOfCellSelected = placesTypeList[indexPath.row]
        celluleIndex = indexPath.row
//        self.photoOfCellSelected = photosList[indexPath.row]
//        self.placeIdCellSelected = placeIDsList[indexPath.row]
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
            detailsPlaceVC.celluleIndex = celluleIndex
//            detailsPlaceVC.photoOfCellule = self.photoOfCellSelected
//            detailsPlaceVC.placeIdCellule = self.placeIdCellSelected
//            detailsPlaceVC.placeDetailsResultsList = self.placeDetailsResultsList
        }
    }
}
