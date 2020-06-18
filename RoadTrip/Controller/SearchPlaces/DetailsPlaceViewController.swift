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
    @IBOutlet private weak var priceLevelLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var userRatingsLabel: UILabel!
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
//    var cellule: Result?
    var photoOfCellule: String?
    var imageOfCellule: String?
    var placeIdCellule: String?
    var placeDetailsResultsList = [ResultDetails]()
    private var coreDataManager: CoreDataManager?
    private var placeIsSaved = false
    
//    var shareInfoPlace: String {
//        guard let namePlace = cellule?.name else { return "" }
//        guard let addressPlace = cellule?.formattedAddress else { return "" }
//        guard let typePlace = cellule?.types.joined(separator: ", ").changeDash.capitalized else { return "" }
//        var website = ""
//        var map = ""
//        var country = ""
//        detailsPlaceToShare(&website, &map, &country)
//        guard let websiteUrl = URL(string: website) else { return "" }
//        guard let mapUrl = URL(string: map) else { return "" }
//        var placeToShare = "🛣 Trip in \(country) 🧳 ! Hello, here is a place I want to visit : \(namePlace) to \(addressPlace) ! \n"
//        placeToShare += "✨ Activities ✨ \(typePlace). \n🌐 \(websiteUrl) \n🗺 \(mapUrl)"
//        print("placeToShare => \(placeToShare)")
//        return placeToShare
//    }
    
    // MARK: - Actions
    
    @IBAction func shareBarButtonItemTapped(_ sender: UIBarButtonItem) {
//        let viewController = UIActivityViewController(activityItems: [shareInfoPlace], applicationActivities: [])
//        present(viewController, animated: true)
//        if let popOver = viewController.popoverPresentationController {
//            popOver.sourceView = self.view
//            popOver.barButtonItem = shareBarButtonItem
//        }
    }
    
    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        if cellule?.extratags.website == nil {
            presentAlert(typeError: .noWebsite)
        }
        openSafari(urlString: cellule?.extratags.website ?? "")
        
//        for placeId in placeDetailsResultsList where placeId.placeID == placeIdCellule {
//            if placeId.website == nil {
//                presentAlert(typeError: .noWebsite)
//            }
//            openSafari(urlString: placeId.website ?? "")
//        }
    }
    
    @IBAction func placeMarkerButtonTapped(_ sender: UIButton) {
        for placeId in placeDetailsResultsList where placeId.placeID == placeIdCellule {
            guard let placeMarkerUrl = placeId.url else { return }
            openSafari(urlString: placeMarkerUrl)
        }
    }
    
//    @IBAction func calendarButtonTapped(_ sender: UIButton) {
//        generateEvent(title: cellule?.name ?? "", location: cellule?.formattedAddress ?? "")
//    }
    
//    @IBAction func saveBarButtonItemTapped(_ sender: UIBarButtonItem) {
//        checkIfPlaceIsSaved()
//        !placeIsSaved ? savePlace() : deletePlace(placeName: cellule?.name,
//                                                  address: cellule?.formattedAddress,
//                                                  coreDataManager: coreDataManager,
//                                                  barButtonItem: bookmarkBarButtonItem)
//    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
        customView(view: violetView, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
        customAllLabels(allLabels: allLabels, radius: 5, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5))
        customAllButtons(allButtons: allButtons, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5), colorBorder: .clear)
        configurePlace()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        checkIfPlaceIsSaved()
    }
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    private func configurePlace() {
        configureDetailsPlace()
        nameLabel.text = cellule?.displayName.cutEndString()
        addressTextView.text += "Address : \(cellule?.displayName.cutStartString() ?? "N/A")"
        openLabel.text = cellule?.extratags.openingHours
//        openLabel.text = open(cellule?.openingHours?.openNow)
        
        // Revoir l'affichage du double
//        ratingLabel.text = String(cellule?.importance ?? 0.0)
        
//        priceLevelLabel.text = priceLevelString(cellule?.priceLevel ?? 0)
        let type = cellule?.type ?? "N/A"
        typesTextView.text += "\n Activities : " + type.capitalized
        loadIcon(imageString: cellule?.icon)
//        userRatingsLabel.text = String(cellule?.userRatingsTotal ?? 0)
        getPhotoPlace()
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
        typesTextView.text = """
        Informations : \n \(openDays) \n \(smoking)
         \(wheelchair) \n \(toiletsWheelchair) \n \(layer)
         \(brewery) \n \(outdoorSeating) \n \(wifi) \n \(tobacco)
        """
        
//        for placeId in placeDetailsResultsList where placeId.placeID == placeIdCellule {
//            if let phoneNumber = placeId.internationalPhoneNumber {
//                addressTextView.text = "Phone : \(phoneNumber) \n"
//            } else {
//                addressTextView.text = "Phone : N/A \n"
//            }
//
//            if let openDays = placeId.openingHours?.weekdayText.joined(separator: "\n") {
//                typesTextView.text = "Opening Days : \n" + (openDays) + "\n"
//            } else {
//                typesTextView.text = "Opening Days : N/A \n"
//            }
//        }
    }
    
//    private func configurePlace() {
//        configureDetailsPlace()
//        let typesList = cellule?.types.joined(separator: ", ") ?? ""
//        nameLabel.text = cellule?.name
//        addressTextView.text += "Address : \(cellule?.formattedAddress ?? "")"
//        openLabel.text = open(cellule?.openingHours?.openNow)
//        ratingLabel.text = String(cellule?.rating ?? 0.0)
//        priceLevelLabel.text = priceLevelString(cellule?.priceLevel ?? 0)
//        typesTextView.text += "Activities : " + typesList.changeDash.capitalized
//        loadIcon(imageString: cellule?.icon)
//        userRatingsLabel.text = String(cellule?.userRatingsTotal ?? 0)
//        getPhotoPlace()
//    }
    
//    private func configureDetailsPlace() {
//        for placeId in placeDetailsResultsList where placeId.placeID == placeIdCellule {
//            if let phoneNumber = placeId.internationalPhoneNumber {
//                addressTextView.text = "Phone : \(phoneNumber) \n"
//            } else {
//                addressTextView.text = "Phone : N/A \n"
//            }
//
//            if let openDays = placeId.openingHours?.weekdayText.joined(separator: "\n") {
//                typesTextView.text = "Opening Days : \n" + (openDays) + "\n"
//            } else {
//                typesTextView.text = "Opening Days : N/A \n"
//            }
//        }
//    }
    
    private func loadIcon(imageString: String?) {
        guard let url = URL(string: imageString ?? "") else { return }
        DispatchQueue.main.async {
            self.iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "europe.png"))
        }
    }
    
    private func getPhotoPlace() {
        let placeholderImage = UIImage(named: "bruges-maison-blanche-belgique_1024x768.jpg")
        let stringUrl = "https://source.unsplash.com/800x600/?\(cellule?.type ?? "")"
        DispatchQueue.main.async {
            self.placeImageView.sd_setImage(with: URL(string: stringUrl), placeholderImage: placeholderImage)
        }
    }
    
//    private func getPhotoPlace() {
//        let placeholderImage = UIImage(named: "bruges-maison-blanche-belgique_1024x768.jpg")
//        let apiKey = valueForAPIKey(named: Constants.PlacesAPIKey)
//        let stringUrl = "https://maps.googleapis.com/maps/api/place/photo?key=\(apiKey)&maxwidth=800&height=600&photoreference=\(photoOfCellule ?? "")"
//        DispatchQueue.main.async {
//            self.placeImageView.sd_setImage(with: URL(string: stringUrl), placeholderImage: placeholderImage)
//        }
//    }
    
    private func detailsPlaceToShare(_ website: inout String, _ map: inout String, _ country: inout String) {
        for placeId in placeDetailsResultsList where placeId.placeID == placeIdCellule {
            website = placeId.website ?? "N/A"
            map = placeId.url ?? ""
            guard let addressComponents = placeId.addressComponents else { return }
            for type in addressComponents {
                for typeCountry in type.types where typeCountry == "country" {
                    country = type.longName
                }
            }
        }
    }
    
    private func open(_ openNow: Bool?) -> String? {
        switch openNow {
        case true:
            return Constants.open
        case false:
            return Constants.closed
        default:
            return Constants.noa
        }
    }
    
//    private func checkIfPlaceIsSaved() {
//        guard let placeName = cellule?.name else { return }
//        guard let address = cellule?.formattedAddress else { return }
//        guard let checkIfPlaceIsSaved = coreDataManager?.checkIfPlaceIsSaved(placeName: placeName, address: address) else { return }
//        placeIsSaved = checkIfPlaceIsSaved
//
//        if placeIsSaved {
//            bookmarkBarButtonItem.tintColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
//        } else {
//            bookmarkBarButtonItem.tintColor = .none
//        }
//    }
    
    private func setDetails(_ country: inout String, _ openDays: inout String, _ phoneNumber: inout String, _ url: inout String, _ website: inout String) {
        for placeId in placeDetailsResultsList where placeId.placeID == placeIdCellule {
            guard let addressComponents = placeId.addressComponents else { return }
            for type in addressComponents {
                for typeCountry in type.types where typeCountry == "country" {
                    country = type.longName
                }
            }
            openDays = placeId.openingHours?.weekdayText.joined(separator: "\n") ?? "N/A"
            phoneNumber = placeId.internationalPhoneNumber ?? "N/A"
            url = placeId.url ?? ""
            website = placeId.website ?? "N/A"
        }
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
