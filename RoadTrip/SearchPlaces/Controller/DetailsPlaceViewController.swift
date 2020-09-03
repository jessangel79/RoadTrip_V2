//
//  DetailsPlaceViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 19/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import SDWebImage

final class DetailsPlaceViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var violetView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var placeImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var openLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var websiteButton: UIButton!
    @IBOutlet private weak var placeMarkerButton: UIButton!
    @IBOutlet private weak var calendarButton: UIButton!
    @IBOutlet private weak var addressTextView: UITextView!
    @IBOutlet private weak var typesTextView: UITextView!
    @IBOutlet private weak var bookmarkBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet private var allLabels: [UILabel]!
    @IBOutlet private var allButtons: [UIButton]!
    
    // MARK: - Properties

    private let placeService = PlaceService()
    var cellule: PlacesSearchElement?
    var photoOfCellule: String?
    var imageOfCellule: String?
    var placeIdCellule: String?
    var placeDetailsResultsList = [ResultDetails]()
    private var coreDataManager: CoreDataManager?
    private var placeIsSaved = false
    private var informations: String?
    
    var shareInfoPlace: String {
        guard let country = cellule?.address.country else { return "Pays N/A" }
        guard let namePlace = cellule?.displayName.cutEndString() else { return "" }
        guard let addressPlace = cellule?.displayName.cutStartString(2) else { return "N/A" }
        guard let typePlace = cellule?.type.changeDash.capitalized else { return "N/A" }
        guard let websiteUrl = URL(string: cellule?.extratags.website ?? "N/A") else { return "" }
        var placeToShare = "🛣 Trip in \(country) 🧳 ! Hello, here is a place I want to visit : \(namePlace) to \(addressPlace) ! \n"
        placeToShare += "✨ Activities ✨ \(typePlace) ✨ \n🌐 \(websiteUrl)"
        print("placeToShare => \(placeToShare)")
        return placeToShare
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
    
    @IBAction func placeMarkerButtonTapped(_ sender: UIButton) {
//        for placeId in placeDetailsResultsList where placeId.placeID == placeIdCellule {
//            guard let placeMarkerUrl = placeId.url else { return }
//            openSafari(urlString: placeMarkerUrl)
//        }
    }
    
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        generateEvent(title: cellule?.displayName.cutEndString() ?? "", location: cellule?.displayName.cutStartString(2) ?? "")
    }

    @IBAction func saveBarButtonItemTapped(_ sender: UIBarButtonItem) {
        checkIfPlaceIsSaved()
        !placeIsSaved ? savePlace() : deletePlace(placeName: cellule?.displayName.cutEndString(),
                                                  address: cellule?.displayName.cutStartString(2),
                                                  coreDataManager: coreDataManager,
                                                  barButtonItem: bookmarkBarButtonItem)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
        customView(view: violetView, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
        customAllLabels(allLabels: allLabels, radius: 5, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5))
        customAllButtons(allButtons: allButtons, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5), colorBorder: .clear)
        customImageView(imageView: iconImageView, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884), colorBorder: UIColor.gray)
        configurePlace()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfPlaceIsSaved()
    }
    
    // MARK: - Methods
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    private func configurePlace() {
        configureDetailsPlace()
        nameLabel.text = cellule?.displayName.cutEndString()
        addressTextView.text += "Address : \(cellule?.displayName.cutStartString(2) ?? "N/A")"
        openLabel.text = setOpeningHours()
        let importance = String(format: "%.1f", cellule?.importance ?? 0.0)
        ratingLabel.text = importanceString(importance)
        let type = cellule?.type ?? "N/A"
        typesTextView.text += "\n Activities : " + type.capitalized
        loadIcon(imageString: cellule?.icon)
        
        // OK /// TEST Offline ///
        self.placeImageView.image = UIImage(named: imagesBackgroundList.randomElement() ?? "val-dorcia-italie_1024x1024.jpg")
        
        // OK => Désactivé pour test
//        loadPhoto(urlString: photoOfCellule)
    }
    
    private func setOpeningHours() -> String {
        var openDays = ""
        if let openingHours = cellule?.extratags.openingHours {
            openDays = openingHours
        } else {
            openDays = "Opening Hours : N/A"
        }
        return openDays
    }
    
    private func configureDetailsPlace() {
        let phoneNumber = cellule?.extratags.phone ?? "N/A"
        addressTextView.text = "Phone : \(phoneNumber) \n"
        let openDays = "- Opening Hours : " + (cellule?.extratags.openingHours ?? "N/A")
        let smoking = "- Smoking : " + (cellule?.extratags.smoking?.capitalized ?? "N/A")
        let wheelchair = "- Wheelchair : " + (cellule?.extratags.wheelchair?.capitalized ?? "N/A")
        let toiletsWheelchair = "- Toilets Wheelchair : " + (cellule?.extratags.toiletsWheelchair?.capitalized ?? "N/A")
        let layer = "- Layer : " + (cellule?.extratags.layer?.capitalized ?? "N/A")
        let brewery = "- Brewery : " + (cellule?.extratags.brewery?.capitalized ?? "N/A")
        let outdoorSeating = "- Outdoor Seating : " + (cellule?.extratags.outdoorSeating?.capitalized ?? "N/A")
        let wifi = "- Wifi : " + (cellule?.extratags.wifi?.capitalized ?? "N/A")
        let tobacco = "- Tobacco : " + (cellule?.extratags.tobacco?.capitalized ?? "N/A")
        informations = """
        Informations : \n \(openDays) \n \(smoking)
         \(wheelchair) \n \(toiletsWheelchair) \n \(layer)
         \(brewery) \n \(outdoorSeating) \n \(wifi) \n \(tobacco)
        """
        typesTextView.text = informations
    }
    
    private func loadIcon(imageString: String?) {
        guard let url = URL(string: imageString ?? "") else { return }
        DispatchQueue.main.async {
            self.iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "europe.png"))
        }
    }
    
    private func loadPhoto(urlString: String?) {
        if let url = URL(string: urlString ?? "") {
            DispatchQueue.main.async {
            self.placeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "bruges-maison-blanche-belgique_1024x768" + ".jpg"))
            }
        } else {
            self.placeImageView.image = UIImage(named: imagesBackgroundList.randomElement() ?? "val-dorcia-italie_1024x1024.jpg")
        }
    }
    
//    private func open(_ openNow: Bool?) -> String? {
//        switch openNow {
//        case true:
//            return Constants.Open
//        case false:
//            return Constants.Closed
//        default:
//            return Constants.Noa
//        }
//    }
    
    private func checkIfPlaceIsSaved() {
        guard let placeName = cellule?.displayName.cutEndString() else { return }
        guard let address = cellule?.displayName.cutStartString(2) else { return }
        guard let checkIfPlaceIsSaved = coreDataManager?.checkIfPlaceIsSaved(placeName: placeName, address: address) else { return }
        placeIsSaved = checkIfPlaceIsSaved

        if placeIsSaved {
            bookmarkBarButtonItem.tintColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        } else {
            bookmarkBarButtonItem.tintColor = .none
        }
    }
    
    private func savePlace() {
        let address = cellule?.displayName.cutStartString(2) ?? ""
        let icon = cellule?.icon ?? ""
        let name = cellule?.displayName.cutEndString() ?? ""
        let photo = photoOfCellule ?? ""
        let importance = String(format: "%.1f", cellule?.importance ?? 0.0)
        let rating = importanceString(importance) ?? ""
        let types = cellule?.type.changeDash.capitalized ?? ""
        let country = cellule?.address.country ?? ""
        let openDays = setOpeningHours() // cellule?.extratags.openingHours ?? ""
        let phoneNumber = cellule?.extratags.phone ?? "N/A"
        let website = cellule?.extratags.website ?? "N/A"
        coreDataManager?.createPlace(parameters: PlaceParameters(address: address, country: country, icon: icon, name: name,
                                                                 openDays: openDays, phoneNumber: phoneNumber, photo: photo,
                                                                 rating: rating, types: types, website: website, informations: informations ?? ""))
        setupBarButtonItem(color: #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1), barButtonItem: bookmarkBarButtonItem)
        debugCoreDataPlace(nameDebug: "Places saved", coreDataManager: coreDataManager)
    }
    
//    private func savePlace() {
//        let address = cellule?.formattedAddress ?? ""
//        let icon = cellule?.icon ?? ""
//        let name = cellule?.name ?? ""
//        let openNow = cellule?.openingHours?.openNow ?? false
//        let photo = photoOfCellule ?? ""
//        let placeID = cellule?.placeID ?? ""
//        let priceLevel = cellule?.priceLevel ?? 0
//        let rating = cellule?.rating ?? 0.0
//        let types = cellule?.types.joined(separator: ", ").changeDash.capitalized ?? ""
//        let userRatingsTotal = cellule?.userRatingsTotal ?? 0
//        var country = String()
//        var openDays = String()
//        var phoneNumber = String()
//        var url = String()
//        var website = String()
//        setDetails(&country, &openDays, &phoneNumber, &url, &website)
//        coreDataManager?.createPlace(parameters: PlaceParameters(address: address, country: country, icon: icon,
//                                                                 name: name, openDays: openDays, openNow: openNow,
//                                                                 phoneNumber: phoneNumber, photo: photo, placeID: placeID,
//                                                                 priceLevel: Int16(priceLevel), rating: rating, types: types,
//                                                                 url: url, userRatingsTotal: Int64(userRatingsTotal), website: website))
//        setupBarButtonItem(color: #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1), barButtonItem: bookmarkBarButtonItem)
//        debugCoreDataPlace(nameDebug: "Places saved", coreDataManager: coreDataManager)
//    }
}
