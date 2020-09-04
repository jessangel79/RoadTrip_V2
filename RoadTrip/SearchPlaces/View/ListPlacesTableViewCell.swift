//
//  ListPlacesTableViewCell.swift
//  RoadTrip
//
//  Created by Angelique Babin on 13/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import SDWebImage

final class ListPlacesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var openLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var ratingView: UIView!
    @IBOutlet private var allLabels: [UILabel]!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var urlPhoto: String?

    // MARK: - Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        customLabelsCell(labels: allLabels, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884), colorBorder: UIColor.gray)
        customViewCell(view: ratingView)
        customImageViewCell(imageView: iconImageView, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7009438452, green: 0.7009438452, blue: 0.7009438452, alpha: 0.6988976884), colorBorder: UIColor.gray)
    }
    
    var place: PlacesSearchElement? {
        didSet {
            nameLabel.text = place?.displayName.cutEndString()
            addressLabel.text = place?.displayName.cutStartString(2)
            openLabel.text = place?.extratags.openingHours ?? "Opening Hours : N/A"
            loadIcon(imageString: place?.icon)
            let importance = String(format: "%.1f", place?.importance ?? 0.0)
            ratingLabel.text = importance.importanceString() ?? ""
            
            // OK /// TEST Offline ///
            placeImageView.image = UIImage(named: imagesBackgroundList.randomElement() ?? "val-dorcia-italie_1024x1024.jpg")

            // OK => Désactivé pour test
//            urlPhoto = urlsList.randomElement()
//            loadPhoto(urlString: urlPhoto)
        }
    }
    
//    var place: Result? {
//        didSet {
//            nameLabel.text = place?.name
//            addressLabel.text = place?.formattedAddress
//            openLabel.text = openResult(place?.openingHours?.openNow)
//            loadIcon(imageString: place?.icon)
//            priceLevelLabel.text = priceLevelString(place?.priceLevel ?? 0)
//            ratingLabel.text = String(place?.rating ?? 0.0)
//            let photo = place?.photos ?? [Photo]()
//            configPhoto(photo)
//        }
//    }
    
    var placeEntity: PlaceEntity? {
        didSet {
            nameLabel.text = placeEntity?.name
            addressLabel.text = placeEntity?.address
            openLabel.text = placeEntity?.openDays ?? ""
            loadIcon(imageString: placeEntity?.icon)
            ratingLabel.text = placeEntity?.rating ?? ""
            let photo = placeEntity?.photo ?? ""
            loadPhoto(urlString: photo)
        }
    }
    
    private func loadIcon(imageString: String?) {
        guard let url = URL(string: imageString ?? "") else { return }
        DispatchQueue.main.async {
            self.iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "europe.png"))
        }
    }
    
    /// get photos with SDWebimage to load images of places
    private func loadPhoto(urlString: String?) {
        if let url = URL(string: urlString ?? "") {
            DispatchQueue.main.async {
            self.placeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "bruges-maison-blanche-belgique_1024x768" + ".jpg"))
            }
        } else {
            self.placeImageView.image = UIImage(named: imagesBackgroundList.randomElement() ?? "val-dorcia-italie_1024x1024.jpg")
        }
    }
    
//    private func openEntity(_ openNow: Bool, _ openDays: String) -> String? {
//         if openNow {
//            return Constants.Open
//         } else if !openNow && openDays != "N/A" {
//            return Constants.Closed
//         } else {
//            return Constants.Noa
//         }
//     }
    
//    private func importanceString(_ importance: String) -> String? {
//        switch importance {
//        case "0.1":
//            return Importance.one.importanceFunc()
//        case "0.2":
//            return Importance.two.importanceFunc()
//        case "0.3":
//            return Importance.three.importanceFunc()
//        case "0.4":
//            return Importance.four.importanceFunc()
//        case "0.5":
//             return Importance.five.importanceFunc()
//        case "0.6":
//             return Importance.six.importanceFunc()
//        case "0.7":
//             return Importance.seven.importanceFunc()
//        case "0.8":
//             return Importance.eight.importanceFunc()
//        case "0.9":
//             return Importance.nine.importanceFunc()
//        default:
//            return Importance.noa.importanceFunc()
//        }
//    }

}
