//
//  SearchPlacesViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

final class SearchPlacesViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var searchPlacesButton: UIButton!
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet private weak var placeTextField: UITextField!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private let placeService = PlaceService()
    private var placesList = [PlacesSearchElement]()
//    private var placesList = [Result]()
//    private var photosList = [String]()
    private var placesTypeList = [String]()
    private var placeIDsList = [String]()
    private var queriesList = [String]()
    private let segueToPlacesList = Constants.SegueToPlacesList

    // MARK: - Actions
    
    @IBAction private func searchButtonTapped(_ sender: UIButton) {
        searchPlaces()
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customButton(button: searchPlacesButton, radius: 30, width: 0.8, colorBackground: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1), colorBorder: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        queriesList = [String]()
//        photosList = [String]()
        placeIDsList = [String]()
        imagesArray = [UIImage]()
    }
    
    private func setQuery() {
        queriesList = [String]()
        guard var place = placeTextField.text, !place.isBlank else { return }
        guard var city = cityTextField?.text, !city.isBlank else { return }
        place = place.stringUrlAllowed
        city = city.stringUrlAllowed
        queriesList += [place, city]
        placeTextField.text = String()
        cityTextField.text = String()
    }
    
    private func searchPlaces() {
        setQuery()
        placeTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        toggleActivityIndicator(shown: true, activityIndicator: activityIndicator, validateButton: searchPlacesButton)
        getPlaces()
    }
    
    /// get photos references  in string
//    private func createPhotosAndIDsList() {
//        for place in placesList {
//            self.placeIDsList.append(place.placeID)
//            if place.photos == nil {
//                self.photosList.append("N/A")
//            }
//            for photoReference in place.photos ?? [Photo]() {
//                self.photosList.append(photoReference.photoReference)
//            }
//        }
//    }
    
//    fileprivate func createImagesArray() {
//        let placeType = place?.type ?? ""
//        loadImages(urlImageString: "https://source.unsplash.com/800x600/?\(placeType)")
//        print("images array : \(imagesArray)")
//    }
//    
//    func loadImages(urlImageString: String?) {
//        let imageView = UIImageView()
//        guard let urlImageString = urlImageString else { return }
//        guard let urlImage = URL(string: urlImageString) else { return }
//        DispatchQueue.global().async { [weak imageView] in
//            if let data = try? Data(contentsOf: urlImage) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        imageView?.image = image
//                    }
//                } else {
//                    imageView?.image = UIImage(named: "bruges-maison-blanche-belgique_1024x768" + ".jpg")
//                }
//            }
//        }
//        for _ in 1...20 {
//            guard let imageViewImage = imageView.image else { return }
//            imagesArray.append(imageViewImage)
//        }
//        print("images array in load test: \(imagesArray)")
//    }
    
    private func createPlacesTypeList() {
        for place in placesList {
            self.placesTypeList.append(place.type)
        }
    }

    private func getPlaces() {
        guard !queriesList.isEmpty else {
            presentAlert(typeError: .isEmpty)
            toggleActivityIndicator(shown: false, activityIndicator: activityIndicator, validateButton: searchPlacesButton)
            return
        }

        placeService.getPlaces(queriesList: queriesList) { (success, placesSearch) in
            self.toggleActivityIndicator(shown: false,
                                         activityIndicator: self.activityIndicator,
                                         validateButton: self.searchPlacesButton)
            if success {
                guard let placesSearch = placesSearch else { return }
                if !placesSearch.isEmpty {
                    self.placesList = placesSearch
    //                    self.placesList = placesSearch.results
                    self.createPlacesTypeList()
    //                    self.createPhotosAndIDsList()
                    self.debugGetPlaces(nameDebug: "debug getPlaces", placesList: self.placesList)
                    self.performSegue(withIdentifier: self.segueToPlacesList, sender: self)
                } else {
                    self.presentAlert(typeError: .zeroResult)
                    self.toggleActivityIndicator(shown: false,
                                                 activityIndicator: self.activityIndicator,
                                                 validateButton: self.searchPlacesButton)
                }
            } else {
                self.presentAlert(typeError: .noPlace)
                self.toggleActivityIndicator(shown: false,
                                             activityIndicator: self.activityIndicator,
                                             validateButton: self.searchPlacesButton)
            }
        }
    }
}

// MARK: - Keyboard

extension SearchPlacesViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        cityTextField.resignFirstResponder()
        placeTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchPlaces()
        return true
    }
}

// MARK: - Navigation

extension SearchPlacesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToPlacesList {
            guard let listPlacesVC = segue.destination as? ListPlacesViewController else { return }
            listPlacesVC.placesList = placesList
//            listPlacesVC.imagesList = imagesList
            listPlacesVC.placesTypeList = placesTypeList
//            listPlacesVC.photosList = photosList
//            listPlacesVC.placeIDsList = placeIDsList
        }
    }
}
