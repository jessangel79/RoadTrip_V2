//
//  DetailsPlaceViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 19/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import SDWebImage

final class MyPlaceViewController: DetailsPlaceViewController {
    
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

    var celluleEntity: PlaceEntity?
    private var coreDataManager: CoreDataManager?
    private var placeIsSaved = false

    override var shareInfoPlace: String {
        guard let country = celluleEntity?.country else { return "Pays N/A" }
        guard let namePlace = celluleEntity?.name else { return "" }
        guard let addressPlace = celluleEntity?.address else { return "N/A" }
        guard let typePlace = celluleEntity?.types else { return "N/A" }
        guard let websiteUrl = URL(string: celluleEntity?.website ?? "N/A") else { return ""}
        var placeToShare = "🛣 Trip in \(country) 🧳 ! Hello, here is a place I want to visit : \(namePlace) to \(addressPlace) ! \n"
        placeToShare += "✨ Activities ✨ \(typePlace) ✨ \n🌐 \(websiteUrl)"
        print("placeToShare => \(placeToShare)")
        return placeToShare
    }

    // MARK: - Actions
    
    @IBAction override func shareBarButtonItemTapped(_ sender: UIBarButtonItem) {
        super.shareBarButtonItemTapped(shareBarButtonItem)
//        let viewController = UIActivityViewController(activityItems: [shareInfoPlace], applicationActivities: [])
//        present(viewController, animated: true)
//        if let popOver = viewController.popoverPresentationController {
//            popOver.sourceView = self.view
//            popOver.barButtonItem = shareBarButtonItem
//        }
    }
    
    @IBAction override func websiteButtonTapped(_ sender: UIButton) {
        if let websiteUrl = celluleEntity?.website {
            if websiteUrl == "N/A" {
                presentAlert(typeError: .noWebsite)
            } else {
                openSafari(urlString: websiteUrl)
            }
        }
    }

    @IBAction override func placeMarkerButtonTapped(_ sender: UIButton) {
//        guard let placeMarkerUrl = cellule?.url else { return }
//        openSafari(urlString: placeMarkerUrl)
    }

    @IBAction override func calendarButtonTapped(_ sender: UIButton) {
        let title = celluleEntity?.name ?? ""
        let location = celluleEntity?.address ?? ""
        super.generateEvent(title: title, location: location)
//        generateEvent(title: celluleEntity?.name ?? "", location: celluleEntity?.address ?? "")
    }

    @IBAction override func saveBarButtonItemTapped(_ sender: UIBarButtonItem) {
        guard let placeName = celluleEntity?.name else { return }
        guard let address = celluleEntity?.address else { return }
        checkIfPlaceIsSaved(placeName: placeName, address: address)
//        checkIfPlaceIsSaved()
        deletePlace(placeName: placeName, address: address, coreDataManager: coreDataManager, barButtonItem: bookmarkBarButtonItem)
//        deletePlace(placeName: celluleEntity?.name, address: celluleEntity?.address, coreDataManager: coreDataManager, barButtonItem: bookmarkBarButtonItem)
        navigationController?.popViewController(animated: true)

    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
//        customUI()
        
        configurePlace()
        
//        guard let placeName = celluleEntity?.name else { return }
//        guard let address = celluleEntity?.address else { return }
//        checkIfPlaceIsSaved(placeName: placeName, address: address)
        
//        checkIfPlaceIsSaved()
    }
    
    // MARK: - Methods

    override func coreDataFunction() {
        super.coreDataFunction()
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let coreDataStack = appDelegate.coreDataStack
//        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    override func customUI() {
//        super.customUI()
        customView(view: violetView, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
        customAllLabels(allLabels: allLabels, radius: 5, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5))
        customAllButtons(allButtons: allButtons, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.5), colorBorder: .clear)
        customImageView(imageView: iconImageView, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884), colorBorder: UIColor.gray)
    }
    
    override func configurePlace() {
        typesTextView.text = celluleEntity?.informations ?? ""
        let typesList = celluleEntity?.types ?? ""
        typesTextView.text += "\n Activities : " + typesList
        guard let phoneNumber = celluleEntity?.phoneNumber else { return }
        nameLabel.text = celluleEntity?.name
        addressTextView.text = "Phone : \(phoneNumber) \n"
        addressTextView.text += "Address : \(celluleEntity?.address ?? "")"
        
//        let openingHours = celluleEntity?.openDays
//        openLabel.text = super.setOpeningHours(openingHours: openingHours ?? "")
        openLabel.text = setOpeningHours()
        ratingLabel.text = celluleEntity?.rating
        
        loadIcon(imageString: celluleEntity?.icon ?? "", iconImageView: iconImageView)
//        super.loadIcon(imageString: celluleEntity?.icon ?? "")
//        loadIcon()
        loadPhoto(urlString: celluleEntity?.photo ?? "")
//        super.loadPhoto(urlString: celluleEntity?.photo)
    }
    
    private func setOpeningHours() -> String {
        var openDays = ""
        if let openingHours = celluleEntity?.openDays {
            openDays = openingHours
        } else {
            openDays = "Opening Hours : N/A"
        }
        return openDays
    }
    
//    override func loadIcon(imageString: String?) {
//        super.loadIcon(imageString: imageString)
//    }
    
    override func configureDetailsPlace() {
        
    }
    
    override func loadIcon(imageString: String?, iconImageView: UIImageView) {
        super.loadIcon(imageString: imageString, iconImageView: iconImageView)
//        guard let url = URL(string: imageString ?? "") else { return }
//        DispatchQueue.main.async {
//            self.iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "europe.png"))
//        }
    }
    
//    private func loadIcon() {
//        guard let url = URL(string: celluleEntity?.icon ?? "") else { return }
//        DispatchQueue.main.async {
//            self.iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "europe.png"))
//        }
//    }
    
//    override func loadPhoto(urlString: String?) {
//        super.loadPhoto(urlString: urlString)
//    }
    
    override func loadPhoto(urlString: String?) {
        if let url = URL(string: urlString ?? "") {
            DispatchQueue.main.async {
            self.placeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "bruges-maison-blanche-belgique_1024x768" + ".jpg"))
            }
        } else {
            self.placeImageView.image = UIImage(named: imagesBackgroundList.randomElement() ?? "val-dorcia-italie_1024x1024.jpg")
        }
    }
    
    override func checkIfPlaceIsSaved(placeName: String, address: String) {
//        super.checkIfPlaceIsSaved(placeName: placeName, address: address)
    }
    
    override func deletePlace(placeName: String?, address: String?, coreDataManager: CoreDataManager?, barButtonItem: UIBarButtonItem) {
        super.deletePlace(placeName: placeName, address: address, coreDataManager: coreDataManager, barButtonItem: barButtonItem)
    }

//    func checkIfPlaceIsSaved() {
//        guard let placeName = celluleEntity?.name else { return }
//        guard let address = celluleEntity?.address else { return }
//        guard let checkIfPlaceIsSaved = coreDataManager?.checkIfPlaceIsSaved(placeName: placeName, address: address) else { return }
//        placeIsSaved = checkIfPlaceIsSaved
//
//        if placeIsSaved {
//            bookmarkBarButtonItem.tintColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
//        } else {
//            bookmarkBarButtonItem.tintColor = .none
//        }
//    }
}
