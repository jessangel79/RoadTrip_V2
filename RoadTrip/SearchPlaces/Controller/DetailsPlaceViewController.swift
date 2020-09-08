//
//  DetailsPlaceViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 19/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import SDWebImage

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
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var typesTextView: UITextView!
    @IBOutlet weak var bookmarkBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet var allLabels: [UILabel]!
    @IBOutlet var allButtons: [UIButton]!
    
    // MARK: - Properties

    var cellule: PlacesSearchElement?
    var photoOfCellule: String?
    var coreDataManager: CoreDataManager?
    var placeIsSaved = false
    private var informations: String?
    let segueToMap = Constants.SegueToMap
    
    var shareInfoPlace: String {
        guard let country = cellule?.address.country else { return "Pays N/A" }
        guard let namePlace = cellule?.displayName.cutEndString() else { return "" }
        guard let addressPlace = cellule?.displayName.cutStartString(2) else { return "N/A" }
        guard let typePlace = cellule?.type.changeDash.capitalized else { return "N/A" }
        guard let websiteUrl = URL(string: cellule?.extratags.website ?? "N/A") else { return "" }
        return placeToShare(country, namePlace, addressPlace, typePlace, websiteUrl)
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
        if cellule?.extratags.website == nil {
            presentAlert(typeError: .noWebsite)
        }
        openSafari(urlString: cellule?.extratags.website ?? "")
    }
    
//    @IBAction func placeMarkerButtonTapped(_ sender: UIButton) {
//        for placeId in placeDetailsResultsList where placeId.placeID == placeIdCellule {
//            guard let placeMarkerUrl = placeId.url else { return }
//            openSafari(urlString: placeMarkerUrl)
//        }
//    }
    
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        let placeName = cellule?.displayName.cutEndString() ?? ""
        let address = cellule?.displayName.cutStartString(2) ?? ""
        generateEvent(title: placeName, location: address)
    }

    @IBAction func saveBarButtonItemTapped(_ sender: UIBarButtonItem) {
        guard let placeName = cellule?.displayName.cutEndString() else { return }
        guard let address = cellule?.displayName.cutStartString(2) else { return }
        checkIfPlaceIsSaved(placeName: placeName, address: address)
        !placeIsSaved ? savePlace() : deletePlace(placeName: placeName, address: address)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
        customUI()
        configureDetailsPlace()
        setCelluleData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let placeName = cellule?.displayName.cutEndString() else { return }
        guard let address = cellule?.displayName.cutStartString(2) else { return }
        checkIfPlaceIsSaved(placeName: placeName, address: address)
    }
    
    // MARK: - Methods
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    private func customUI() {
        customView(view: violetView, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
        customAllLabels(allLabels: allLabels, radius: 5, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5))
        customAllButtons(allButtons: allButtons, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5), colorBorder: .clear)
        customImageView(imageView: iconImageView, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884), colorBorder: UIColor.gray)
    }
    
    func placeToShare(_ country: String, _ namePlace: String, _ addressPlace: String, _ typePlace: String, _ websiteUrl: URL) -> String {
        var placeToShare = "🛣 Trip in \(country) 🧳 ! Hello, here is a place I want to visit : \(namePlace) to \(addressPlace) ! \n"
        placeToShare += "✨ Activities ✨ \(typePlace) ✨ \n🌐 \(websiteUrl)"
        print("placeToShare => \(placeToShare)")
        return placeToShare
    }
    
    private func configureDetailsPlace() {
        let openDays = "- Opening Hours : " + (cellule?.extratags.openingHours ?? "N/A")
        let smoking = "- Smoking : " + (cellule?.extratags.smoking?.capitalized ?? "N/A")
        let wheelchair = "- Wheelchair : " + (cellule?.extratags.wheelchair?.capitalized ?? "N/A")
        let toiletsWheelchair = "- Toilets Wheelchair : " + (cellule?.extratags.toiletsWheelchair?.capitalized ?? "N/A")
        let layer = "- Layer : " + (cellule?.extratags.layer?.capitalized ?? "N/A")
        let brewery = "- Brewery : " + (cellule?.extratags.brewery?.capitalized ?? "N/A")
        let outdoorSeating = "- Outdoor Seating : " + (cellule?.extratags.outdoorSeating?.capitalized ?? "N/A")
        let wifi = "- Wifi : " + (cellule?.extratags.wifi?.capitalized ?? "N/A")
        let tobacco = "- Tobacco : " + (cellule?.extratags.tobacco?.capitalized ?? "N/A")
        
        informations = setInformations(parameters: DetailsPlaceParameters(
            openDays: openDays, smoking: smoking, wheelchair: wheelchair,
            toiletsWheelchair: toiletsWheelchair, layer: layer,
            brewery: brewery, outdoorSeating: outdoorSeating,
            wifi: wifi, tobacco: tobacco))
    }
    
    private func setCelluleData() {
        let name = cellule?.displayName.cutEndString() ?? ""
        let phoneNumber = cellule?.extratags.phone ?? "N/A"
        let address = cellule?.displayName.cutStartString(2) ?? "N/A"
        let openHours = setOpeningHours(openingHours: cellule?.extratags.openingHours)
        let types = cellule?.type.capitalized ?? "N/A"
//        let types = "\n Activities : " + (cellule?.type ?? "N/A").capitalized
        let importance = String(format: "%.1f", cellule?.importance ?? 0.0)
        let rating = importance.importanceString() ?? ""
        let icon = cellule?.icon ?? ""
        let country = cellule?.address.country ?? ""
        let website = cellule?.extratags.website ?? ""
        let photo = photoOfCellule ?? ""
        let informations = self.informations ?? ""
        let lat = cellule?.lat ?? ""
        let lon = cellule?.lon ?? ""
        
        configurePlace(parameters: PlaceParameters(
            address: address, country: country, icon: icon,
            name: name, openDays: openHours, phoneNumber: phoneNumber,
            photo: photo, rating: rating, types: types,
            website: website, informations: informations, lat: lat, lon: lon))
    }
    
    func configurePlace(parameters: PlaceParameters) {
        nameLabel.text = parameters.name
        addressTextView.text = "Phone : \(parameters.phoneNumber) \n"
        addressTextView.text += "Address : \(parameters.address)"
        openLabel.text = parameters.openDays
        typesTextView.text = parameters.informations + "\n Activities : \(parameters.types)"
        ratingLabel.text = parameters.rating
        loadIcon(imageString: parameters.icon)
        setPhoto(parameters)
    }
    
    private func setInformations(parameters: DetailsPlaceParameters) -> String? {
        informations = """
        Informations : \n \(parameters.openDays) \n \(parameters.smoking)
        \(parameters.wheelchair) \n \(parameters.toiletsWheelchair) \n \(parameters.layer)
        \(parameters.brewery) \n \(parameters.outdoorSeating) \n \(parameters.wifi) \n \(parameters.tobacco)
        """
        return informations
    }
    
    func setOpeningHours(openingHours: String?) -> String {
        var openDays = ""
        if let openingHours = openingHours {
            openDays = openingHours
        } else {
            openDays = "Opening Hours : N/A"
        }
        return openDays
    }
    
    private func loadIcon(imageString: String?) {
        guard let url = URL(string: imageString ?? "") else { return }
        DispatchQueue.main.async {
            self.iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "europe.png"))
        }
    }
    
    private func setPhoto(_ parameters: PlaceParameters) {
        if !parameters.photo.isEmpty {
            loadPhoto(urlString: parameters.photo)
        } else {
            self.placeImageView.image = UIImage(named: imagesBackgroundList.randomElement() ?? "val-dorcia-italie_1024x1024.jpg")
        }
    }
    
    private func loadPhoto(urlString: String?) {
        if let url = URL(string: urlString ?? "") {
            DispatchQueue.main.async {
            self.placeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "bruges-maison-blanche-belgique_1024x768" + ".jpg"))
            }
        }
    }
    
    func checkIfPlaceIsSaved(placeName: String, address: String) {
        guard let checkIfPlaceIsSaved = coreDataManager?.checkIfPlaceIsSaved(placeName: placeName, address: address) else { return }
        placeIsSaved = checkIfPlaceIsSaved
        placeIsSaved ? setBookmarkBarButtonItem(color: #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)) : setBookmarkBarButtonItem(color: .none)

    }

    private func savePlace() {
        let address = cellule?.displayName.cutStartString(2) ?? ""
        let icon = cellule?.icon ?? ""
        let name = cellule?.displayName.cutEndString() ?? ""
        let photo = photoOfCellule ?? ""
        let importance = String(format: "%.1f", cellule?.importance ?? 0.0)
        let rating = importance.importanceString() ?? ""
        let types = cellule?.type.changeDash.capitalized ?? "N/A"
        let country = cellule?.address.country ?? ""
        let openDays = setOpeningHours(openingHours: cellule?.extratags.openingHours)
        let phoneNumber = cellule?.extratags.phone ?? "N/A"
        let website = cellule?.extratags.website ?? "N/A"
        let informations = self.informations ?? ""
        let lat = cellule?.lat ?? ""
        let lon = cellule?.lon ?? ""
        coreDataManager?.createPlace(parameters: PlaceParameters(address: address, country: country, icon: icon, name: name,
                                                                 openDays: openDays, phoneNumber: phoneNumber, photo: photo,
                                                                 rating: rating, types: types, website: website, informations: informations, lat: lat, lon: lon))
        setBookmarkBarButtonItem(color: #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1))
        debugCoreDataPlace(nameDebug: "Places saved", coreDataManager: coreDataManager)
    }

    /// Delete place
    func deletePlace(placeName: String?, address: String?) {
        coreDataManager?.deletePlace(placeName: placeName ?? "", address: address ?? "")
        setBookmarkBarButtonItem(color: .none)
        debugCoreDataPlace(nameDebug: "Place deleted", coreDataManager: coreDataManager)
    }
    
    /// Manage the button bookmark of places saved
    private func setBookmarkBarButtonItem(color: UIColor?) {
        bookmarkBarButtonItem.tintColor = color
//        navigationItem.rightBarButtonItem = barButtonItem
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
