//
//  DetailsPlaceViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 19/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import SDWebImage

final class MyPlaceViewController: UIViewController {
    
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

    var cellule: PlaceEntity?
    private var coreDataManager: CoreDataManager?
    private var placeIsSaved = false

    var shareInfoPlace: String {
        guard let namePlace = cellule?.name else { return "" }
        guard let addressPlace = cellule?.address else { return "" }
        guard let country = cellule?.country else { return "" }
        guard let typePlace = cellule?.types?.changeDash.capitalized else { return "" }
        guard let websiteUrl = URL(string: cellule?.website ?? "") else { return ""}
        guard let mapUrl = URL(string: cellule?.url ?? "") else { return "" }
        var placeToShare = "🛣 Trip in \(country) 🧳 ! Hello, here is a place I want to visit : \(namePlace) to \(addressPlace) ! \n"
        placeToShare += "✨ Activities ✨ \(typePlace). \n🌐 \(websiteUrl) \n🗺 \(mapUrl)"
        print("placeToShare => \(placeToShare)")
        return placeToShare
    }

    // MARK: - Actions
    
    @IBAction private func shareBarButtonItemTapped(_ sender: UIBarButtonItem) {
        let viewController = UIActivityViewController(activityItems: [shareInfoPlace], applicationActivities: [])
        present(viewController, animated: true)
        if let popOver = viewController.popoverPresentationController {
            popOver.sourceView = self.view
            popOver.barButtonItem = shareBarButtonItem
        }
    }
    
    @IBAction private func websiteButtonTapped(_ sender: UIButton) {
        if let websiteUrl = cellule?.website {
            if websiteUrl == "N/A" {
                presentAlert(typeError: .noWebsite)
            } else {
                openSafari(urlString: websiteUrl)
            }
        }
    }

    @IBAction private func placeMarkerTappedButton(_ sender: UIButton) {
        guard let placeMarkerUrl = cellule?.url else { return }
        openSafari(urlString: placeMarkerUrl)
    }

    @IBAction private func calendarTappedButton(_ sender: UIButton) {
        generateEvent(title: cellule?.name ?? "", location: cellule?.address ?? "")
    }

    @IBAction private func bookmarkBarButtonItemTapped(_ sender: UIBarButtonItem) {
        checkIfPlaceIsSaved()
        deletePlace(placeName: cellule?.name, address: cellule?.address, coreDataManager: coreDataManager, barButtonItem: bookmarkBarButtonItem)
        navigationController?.popViewController(animated: true)

    }

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
        customView(view: violetView, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
        customAllLabels(allLabels: allLabels, radius: 5, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5))
        customAllButtons(allButtons: allButtons, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5), colorBorder: .clear)
        configurePlace()
        checkIfPlaceIsSaved()
    }
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    private func configurePlace() {
        var openDaysTemp = ""
        typesTextView.text = setOpenDaysPlace(&openDaysTemp)
        let typesList = cellule?.types ?? ""
        typesTextView.text += "Activities : " + typesList
        guard let phoneNumber = cellule?.phoneNumber else { return }
        
        nameLabel.text = cellule?.name
        addressTextView.text = "Phone : \(phoneNumber) \n"
        addressTextView.text += "Address : \(cellule?.address ?? "")"
        openLabel.text = open(cellule?.openNow ?? false, openDaysTemp)
        ratingLabel.text = String(cellule?.rating ?? 0.0)
        priceLevelLabel.text = priceLevelString(Int(cellule?.priceLevel ?? 0))
        iconImageView.sd_setImage(with: URL(string: cellule?.icon ?? ""), placeholderImage: UIImage(named: "europe.png"))
        userRatingsLabel.text = String(cellule?.userRatingsTotal ?? 0)
        getPhotoPlace()
    }
    
    private func setOpenDaysPlace(_ openDaysTemp: inout String) -> String {
        if let openDays = cellule?.openDays {
            openDaysTemp = openDays
        }
        return "Opening Days : \n" + (openDaysTemp) + "\n"
    }

    private func getPhotoPlace() {
        let placeholderImage = UIImage(named: "bruges-maison-blanche-belgique_1024x768.jpg")
        let apiKey = valueForAPIKey(named: Constants.PlacesAPIKey)
        let stringUrl = "https://maps.googleapis.com/maps/api/place/photo?key=\(apiKey)&maxwidth=800&height=600&photoreference=\(cellule?.photo ?? "")"
        placeImageView.sd_setImage(with: URL(string: stringUrl), placeholderImage: placeholderImage)
    }
    
    private func open(_ openNow: Bool, _ openDays: String) -> String {
        if openNow {
            return "Open"
        } else if !openNow && openDays != "N/A" {
            return "Closed"
        } else {
            return "N/A"
        }
    }

    private func checkIfPlaceIsSaved() {
        guard let placeName = cellule?.name else { return }
        guard let address = cellule?.address else { return }
        guard let checkIfPlaceIsSaved = coreDataManager?.checkIfPlaceIsSaved(placeName: placeName, address: address) else { return }
        placeIsSaved = checkIfPlaceIsSaved

        if placeIsSaved {
            bookmarkBarButtonItem.tintColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        } else {
            bookmarkBarButtonItem.tintColor = .none
        }
    }
}
