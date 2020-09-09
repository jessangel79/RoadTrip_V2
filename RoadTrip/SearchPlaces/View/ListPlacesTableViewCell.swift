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
        customCell()
    }
    
    private func customCell() {
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
            
            if !urlsList.isEmpty {
                urlPhoto = urlsList.randomElement()
                loadPhoto(urlString: urlPhoto)
            } else {
                self.placeImageView.image = UIImage(named: imagesBackgroundList.randomElement() ?? "val-dorcia-italie_1024x1024.jpg")
            }
        }
    }
    
    var placeEntity: PlaceEntity? {
        didSet {
            nameLabel.text = placeEntity?.name
            addressLabel.text = placeEntity?.address
            openLabel.text = placeEntity?.openDays ?? ""
            loadIcon(imageString: placeEntity?.icon)
            ratingLabel.text = placeEntity?.rating ?? ""
            let photo = placeEntity?.photo ?? ""
            setPhoto(photo)
        }
    }
    
    private func loadIcon(imageString: String?) {
        guard let url = URL(string: imageString ?? "") else { return }
        DispatchQueue.main.async {
            self.iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "europe.png"))
        }
    }
    
    private func setPhoto(_ photo: String) {
        if !photo.isEmpty {
            urlPhoto = urlsList.randomElement()
            loadPhoto(urlString: photo)
        } else {
            self.placeImageView.image = UIImage(named: imagesBackgroundList.randomElement() ?? "val-dorcia-italie_1024x1024.jpg")
        }
    }
    
    /// get photos with SDWebimage to load images of places
    private func loadPhoto(urlString: String?) {
        if let url = URL(string: urlString ?? "") {
            DispatchQueue.main.async {
            self.placeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "bruges-maison-blanche-belgique_1024x768" + ".jpg"))
            }
        }
    }
}
