//
//  Constants.swift
//  RoadTrip
//
//  Created by Angelique Babin on 13/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

// MARK: - Trick to get static variable in Swift

struct Constants {
    static let ListPlacesCell = "ListPlacesCell"
    static let ListPlacesTableViewCell = "ListPlacesTableViewCell"
    static let PlacesAPIKey = "PlacesAPIKey"
    static let SegueToPlacesList = "segueToPlacesList"
    static let SegueToPlaceDetails = "segueToPlaceDetails"
    static let SegueToMyPlace = "segueToMyPlace"
    static let SegueToAddDetails = "segueToAddDetails"
    static let DetailsMyTripCell = "DetailsMyTripCell"
    static let DetailsMyTripTableViewCell = "DetailsMyTripTableViewCell"
    static let PackingListCell = "PackingListCell"
    static let PackingListTableViewCell = "PackingListTableViewCell"
    static let open = OpenNow.open.openNow()
    static let closed = OpenNow.closed.openNow()
    static let noa = OpenNow.noa.openNow()
}
