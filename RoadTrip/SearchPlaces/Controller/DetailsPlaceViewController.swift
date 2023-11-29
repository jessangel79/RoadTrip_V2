//
//  DetailsPlaceViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 19/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import SDWebImage

import GoogleMobileAds

class DetailsPlaceViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var violetView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var placeMarkerButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var bookmarkBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet var allLabels: [UILabel]!
    @IBOutlet var allButtons: [UIButton]!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    // MARK: - Properties

    var cellule: PlacesSearchElement?
    var photoOfCellule: String?
    var coreDataManager: CoreDataManager?
    var placeIsSaved = false
    private var informations: String?
    let segueToMap = Constants.SegueToMap
    var placeName = String()
    var address = String()
    let dataManager = DataManager()
    let adMobService = AdMobService()
//    var isViewDidAppearCalled = false
    
    var shareInfoPlace: String {
        guard let country = cellule?.address.country else { return "Pays N/A" }
        guard let types = cellule?.type.changeDash.capitalized else { return "N/A" }
        guard let websiteUrl = URL(string: cellule?.extratags?.website ?? "N/A") else { return "" }
        return placeToShare(country, placeName, address, types, websiteUrl)
    }
    
    // MARK: - Actions
    
    @IBAction func shareBarButtonItemTapped(_ sender: UIBarButtonItem) {
        let viewController = UIActivityViewController(activityItems: [shareInfoPlace], applicationActivities: [])
        present(viewController, animated: true)
        if let popOver = viewController.popoverPresentationController {
            popOver.sourceView = self.view
            popOver.barButtonItem = shareBarButtonItem
        }
    }
    
    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        if cellule?.extratags?.website == nil {
            presentAlert(typeError: .noWebsite)
        }
        openSafari(cellule?.extratags?.website ?? "")
    }
    
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        generateEvent(title: placeName, location: address)
    }

    @IBAction func saveBarButtonItemTapped(_ sender: UIBarButtonItem) {
        checkIfPlaceIsSaved()
        if !placeIsSaved {
            savePlace()
        } else {
            deletePlace()
        }
//        !placeIsSaved ? savePlace() : deletePlace()
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adMobService.setAdMob(bannerView, self)
        adMobService.adMobCanRequestAdsLoadBannerAd(bannerView, view)
        coreDataFunction()
        customUI()
        configureDetailsPlace()
        setCelluleData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfPlaceIsSaved()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adMobService.adMobCanRequestAdsLoadBannerAd(bannerView, view)
//        isViewDidAppearCalled = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { [self] _ in
            adMobService.adMobCanRequestAdsLoadBannerAd(bannerView, view)
        }
    }
    
    // MARK: - Methods
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    private func customUI() {
        customView(view: violetView, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
        customAllLabels(allLabels: allLabels, radius: 5, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.7491052893))
        customAllButtons(allButtons: allButtons, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5), colorBorder: .clear)
        customImageView(imageView: iconImageView, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884), colorBorder: UIColor.gray)
    }
    
    func placeToShare(_ country: String, _ placeName: String, _ address: String, _ types: String, _ websiteUrl: URL) -> String {
        let country = "🛣 Trip in \(country) 🧳 ! "
        let placeName = "Hello, here is a place I want to visit : \(placeName) "
        let address = "to \(address) ! \n"
        let activities = "✨ Activities ✨ \(types) ✨ \n🌐 \(websiteUrl)"
        let placeToShare = country + placeName + address + activities
        return placeToShare
    }
    
    private func configureDetailsPlace() {
        let openDays = "- Opening Hours : " + (cellule?.extratags?.openingHours ?? "N/A")
        let smoking = "- Smoking : " + (cellule?.extratags?.smoking?.capitalized ?? "N/A")
        let wheelchair = "- Wheelchair : " + (cellule?.extratags?.wheelchair?.capitalized ?? "N/A")
        let toiletsWheelchair = "- Toilets Wheelchair : " + (cellule?.extratags?.toiletsWheelchair?.capitalized ?? "N/A")
        let layer = "- Layer : " + (cellule?.extratags?.layer?.capitalized ?? "N/A")
        let brewery = "- Brewery : " + (cellule?.extratags?.brewery?.capitalized ?? "N/A")
        let outdoorSeating = "- Outdoor Seating : " + (cellule?.extratags?.outdoorSeating?.capitalized ?? "N/A")
        let wifi = "- Wifi : " + (cellule?.extratags?.wifi?.capitalized ?? "N/A")
//        let tobacco = "- Tobacco : " + (cellule?.extratags.tobacco?.capitalized ?? "N/A")
        let email = "- Email : " + (cellule?.extratags?.email?.capitalized ?? "N/A")
                        
        informations = setInformations(parameters: DetailsPlaceParameters(
            openDays: openDays, smoking: smoking, wheelchair: wheelchair,
            toiletsWheelchair: toiletsWheelchair, layer: layer,
            brewery: brewery, outdoorSeating: outdoorSeating,
            wifi: wifi, email: email))

//        informations = setInformations(parameters: DetailsPlaceParameters(
//            openDays: openDays, smoking: "smoking", wheelchair: "wheelchair",
//            toiletsWheelchair: "toiletsWheelchair", layer: "layer",
//            brewery: "brewery", outdoorSeating: "outdoorSeating",
//            wifi: "wifi", tobacco: tobacco))
    }
    
    func setCelluleData() {
        placeName = cellule?.displayName.cutEndString() ?? ""
        address = cellule?.displayName.cutStartString(2) ?? "N/A"
        let phoneNumber = cellule?.extratags?.phone ?? "N/A"
        let openHours = dataManager.setOpeningHours(openingHours: cellule?.extratags?.openingHours)
        let types = cellule?.type.capitalized ?? "N/A"
        let importance = String(format: "%.1f", cellule?.importance ?? 0.0)
        let rating = importance.importanceString() ?? ""
        let icon = cellule?.icon ?? ""
        let country = cellule?.address.country ?? ""
        let website = cellule?.extratags?.website ?? ""
        let photo = photoOfCellule ?? ""
        let informations = self.informations ?? ""
        let lat = cellule?.lat ?? ""
        let lon = cellule?.lon ?? ""
        
        configurePlace(parameters: PlaceParameters(
            address: address, country: country, icon: icon,
            name: placeName, openDays: openHours, phoneNumber: phoneNumber,
            photo: photo, rating: rating, types: types,
            website: website, informations: informations, lat: lat, lon: lon))
    }
    
    func configurePlace(parameters: PlaceParameters) {
        let phone = "Phone : \(parameters.phoneNumber) \n"
        let address = "Address : \(parameters.address) \n"
        let info = "Informations : \(parameters.informations) \n"
        let type = "Activities : \(parameters.types)"
        nameLabel.text = parameters.name
        detailsTextView.text = phone + address + info + type
        openLabel.text = parameters.openDays
        ratingLabel.text = parameters.rating
        loadIcon(imageString: parameters.icon)
        setPhoto(parameters)
    }
    
    private func setInformations(parameters: DetailsPlaceParameters) -> String? {
        informations = """
        \n \(parameters.openDays) \n \(parameters.smoking) \n \(parameters.wheelchair) \n \(parameters.toiletsWheelchair) \n \(parameters.layer) \n \(parameters.brewery) \n \(parameters.outdoorSeating) \n \(parameters.wifi) \n \(parameters.email)
        """
        return informations
    }
    
    private func loadIcon(imageString: String?) {
        guard let url = URL(string: imageString ?? "") else { return }
        DispatchQueue.main.async {
            self.iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constants.PlaceHolderIcon))
        }
    }
    
    private func setPhoto(_ parameters: PlaceParameters) {
        if !parameters.photo.isEmpty {
            loadPhoto(urlString: parameters.photo)
        } else {
            self.placeImageView.image = UIImage(named: imagesBackgroundList.randomElement() ?? Constants.PlaceHolderPhotoBackgd)
        }
    }
    
    private func loadPhoto(urlString: String?) {
        if let url = URL(string: urlString ?? "") {
            DispatchQueue.main.async {
                self.placeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constants.PlaceHolderPhoto))
            }
        }
    }
    
    func checkIfPlaceIsSaved() {
        guard let checkIfPlaceIsSaved = coreDataManager?.checkIfPlaceIsSaved(placeName: placeName, address: address) else { return }
        placeIsSaved = checkIfPlaceIsSaved
        if placeIsSaved {
            setBookmarkBarButtonItem(color: #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1))
        } else {
            setBookmarkBarButtonItem(color: .none)
        }
        //        placeIsSaved ? setBookmarkBarButtonItem(color: #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)) : setBookmarkBarButtonItem(color: .none)
        
    }

    private func savePlace() {
        dataManager.savePlace(cellule: cellule, photoOfCellule: photoOfCellule, informations: &informations, coreDataManager: coreDataManager)
        setBookmarkBarButtonItem(color: #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1))
    }

    /// Delete place
    func deletePlace() {
        coreDataManager?.deletePlace(placeName: placeName, address: address)
        setBookmarkBarButtonItem(color: .none)
    }
    
    /// Manage the button bookmark of places saved
    private func setBookmarkBarButtonItem(color: UIColor?) {
        bookmarkBarButtonItem.tintColor = color
    }
}

// MARK: - Navigation

extension DetailsPlaceViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToMap {
            guard let mapVC = segue.destination as? MapViewController else { return }
            mapVC.cellule = self.cellule
        }
    }
}
