//
//  PlacesSearchElement.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

// MARK: - PlacesSearchElement

struct PlacesSearchElement: Decodable {
    let lat, lon, displayName: String
    let type: String
    let importance: Double
    let icon: String?
    let address: Address
    let extratags: Extratags?

    enum CodingKeys: String, CodingKey {
        case lat, lon
        case displayName = "display_name"
        case type, importance
        case icon
        case address
        case extratags
    }
}

// MARK: - Address

struct Address: Decodable {
    let country: String

    enum CodingKeys: String, CodingKey {
        case country
    }
}

// MARK: - Extratags

struct Extratags: Decodable {
    let phone: String?
    let website: String?
    let wheelchair: String?
    let toiletsWheelchair: String?
    let layer: String?
    let brewery: String?
    let openingHours: String?
    let outdoorSeating: String?
    let wifi: String?
    //    let tobacco: String?
    let smoking: String?
    let email: String?
    
    enum CodingKeys: String, CodingKey {
        case phone, website
        case wheelchair
        case toiletsWheelchair = "toilets:wheelchair"
        case layer
        case brewery
        case openingHours = "opening_hours"
        case outdoorSeating = "outdoor_seating"
        case wifi
        //        case tobacco
        case smoking
        case email
    }
}

// struct Extratags: Decodable {
//    let phone: String?
//    let website: String?
//    let smoking, wheelchair, toiletsWheelchair, layer: String?
//    let brewery, openingHours, outdoorSeating, wifi: String?
//    let tobacco: String?
//
//    enum CodingKeys: String, CodingKey {
//        case phone, website, smoking, wheelchair
//        case toiletsWheelchair = "toilets:wheelchair"
//        case layer, brewery
//        case openingHours = "opening_hours"
//        case outdoorSeating = "outdoor_seating"
//        case wifi, tobacco
//    }
// }

typealias PlacesSearch = [PlacesSearchElement]
