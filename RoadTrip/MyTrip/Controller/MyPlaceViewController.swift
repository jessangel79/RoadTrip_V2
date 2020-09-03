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

    var cellule: PlaceEntity?
    private var coreDataManager: CoreDataManager?
    private var placeIsSaved = false

    var shareInfoPlace: String {
        guard let country = cellule?.country else { return "Pays N/A" }
        guard let namePlace = cellule?.name else { return "" }
        guard let addressPlace = cellule?.address else { return "N/A" }
        guard let typePlace = cellule?.types else { return "N/A" }
        guard let websiteUrl = URL(string: cellule?.website ?? "N/A") else { return ""}
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
        if let websiteUrl = cellule?.website {
            if websiteUrl == "N/A" {
                presentAlert(typeError: .noWebsite)
            } else {
                openSafari(urlString: websiteUrl)
            }
        }
    }

    @IBAction private func placeMarkerButtonTapped(_ sender: UIButton) {
//        guard let placeMarkerUrl = cellule?.url else { return }
//        openSafari(urlString: placeMarkerUrl)
    }

    @IBAction private func calendarButtonTapped(_ sender: UIButton) {
        generateEvent(title: cellule?.name ?? "", location: cellule?.address ?? "")
    }

    @IBAction private func bookmarkBarButtonItemTapped(_ sender: UIBarButtonItem) {
        checkIfPlaceIsSaved()
        deletePlace(placeName: cellule?.name, address: cellule?.address, coreDataManager: coreDataManager, barButtonItem: bookmarkBarButtonItem)
        navigationController?.popViewController(animated: true)

    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
        customView(view: violetView, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
        customAllLabels(allLabels: allLabels, radius: 5, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5))
        customAllButtons(allButtons: allButtons, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5), colorBorder: .clear)
        configurePlace()
        checkIfPlaceIsSaved()
    }
    
    // MARK: - Methods

    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    private func configurePlace() {
        typesTextView.text = cellule?.informations ?? ""
        let typesList = cellule?.types ?? ""
        typesTextView.text += "\n Activities : " + typesList
        guard let phoneNumber = cellule?.phoneNumber else { return }
        nameLabel.text = cellule?.name
        addressTextView.text = "Phone : \(phoneNumber) \n"
        addressTextView.text += "Address : \(cellule?.address ?? "")"
        openLabel.text = setOpeningHours()
        ratingLabel.text = cellule?.rating
        loadIcon()
        
//        urlPhoto = urlsList.randomElement()
//        loadPhoto(urlString: urlPhoto)
        
        loadPhoto(urlString: cellule?.photo)
    }
    
    private func setOpeningHours() -> String {
        var openDays = ""
        if let openingHours = cellule?.openDays {
            openDays = openingHours
        } else {
            openDays = "Opening Hours : N/A"
        }
        return openDays
    }
    
    private func loadIcon() {
        guard let url = URL(string: cellule?.icon ?? "") else { return }
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
