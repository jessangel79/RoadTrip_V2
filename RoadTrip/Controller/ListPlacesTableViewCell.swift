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
    @IBOutlet private weak var priceLevelLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var ratingView: UIView!
    @IBOutlet private var allLabels: [UILabel]!
    
    // MARK: - Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        customLabelsCell(labels: allLabels)
        customViewCell(view: ratingView)
    }
    
    var place: Result? {
        didSet {
            nameLabel.text = place?.name
            addressLabel.text = place?.formattedAddress
            openLabel.text = openResult(place?.openingHours?.openNow)
            iconImageView.sd_setImage(with: URL(string: place?.icon ?? ""), placeholderImage: UIImage(named: "europe.png"))
            priceLevelLabel.text = priceLevelString(place?.priceLevel ?? 0)
            ratingLabel.text = String(place?.rating ?? 0.0)
            let photo = place?.photos ?? [Photo]()
            configPhoto(photo)
            
//            print("photoReference in place => \(photo)")
//            print("listPlacesCell.placeImageView.image in listTVCell => \(String(describing: placeImageView.image)))")
        }
    }
    
    var placeEntity: PlaceEntity? {
        didSet {
            nameLabel.text = placeEntity?.name
            addressLabel.text = placeEntity?.address
            openLabel.text = openEntity(placeEntity?.openNow ?? false, placeEntity?.openDays ?? "")
            iconImageView.sd_setImage(with: URL(string: placeEntity?.icon ?? ""), placeholderImage: UIImage(named: "europe.png"))
            priceLevelLabel.text = priceLevelString(Int(placeEntity?.priceLevel ?? 0))
            ratingLabel.text = String(placeEntity?.rating ?? 0.0)
            let photo = placeEntity?.photo
            getPhotos(photoReference: photo)
            
//            print("photoReference in placeEntity => \(String(describing: photo))")
//            print("listPlacesCell.placeImageView.image in listTVCell => \(String(describing: placeImageView.image)))")

        }
    }
    
    private func configPhoto(_ photo: [Photo]) {
        var photoReference = String()
        if !photo.isEmpty {
            for photoRef in photo {
                photoReference = photoRef.photoReference
            }
        } else {
            photoReference = String()
        }
        getPhotos(photoReference: photoReference)
    }
    
    /// get photos with SDWebimage to load photos of places
    private func getPhotos(photoReference: String?) {
        let apiKey = valueForAPIKey(named: Constants.PlacesAPIKey)
        let placeholderImage = UIImage(named: "bruges-maison-blanche-belgique_1024x768.jpg")
        guard let photoReference = photoReference else { return }
        let stringUrl = "https://maps.googleapis.com/maps/api/place/photo?key=\(apiKey)&maxwidth=800&height=600&photoreference=\(photoReference)"
        placeImageView.sd_setImage(with: URL(string: stringUrl), placeholderImage: placeholderImage)
    }
    
    private func openResult(_ openNow: Bool?) -> String {
        switch openNow {
        case true:
            return "Open"
        case false:
            return "Closed"
        default:
            return "n/a"
        }
    }
    
    private func openEntity(_ openNow: Bool, _ openDays: String) -> String {
         if openNow {
             return "Open"
         } else if !openNow && openDays != "N/A" {
             return "Closed"
         } else {
             return "n/a"
         }
     }
    
    private func priceLevelString(_ priceLevel: Int) -> String {
        switch priceLevel {
        case 1:
            return "€"
        case 2:
            return "€€"
        case 3:
            return "€€€"
        case 4:
            return "€€€€"
        default:
            return "N/A"
        }
    }
}
