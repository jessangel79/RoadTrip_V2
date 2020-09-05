//
//  PlacesSearch.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

// MARK: - PlacesSearchElement

struct PlacesSearchElement: Decodable {
    let placeID: Int
    let licence: String
    let osmType: String
    let osmID: Int
    let boundingbox: [String]
    let lat, lon, displayName: String
    let type: String
    let importance: Double
    let icon: String
    let address: Address
    let extratags: Extratags

    enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
        case licence
        case osmType = "osm_type"
        case osmID = "osm_id"
        case boundingbox, lat, lon
        case displayName = "display_name"
        case type, importance, icon
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
    let smoking, wheelchair, toiletsWheelchair, layer: String?
    let brewery, openingHours, outdoorSeating, wifi: String?
    let tobacco: String?

    enum CodingKeys: String, CodingKey {
        case phone, website, smoking, wheelchair
        case toiletsWheelchair = "toilets:wheelchair"
        case layer, brewery
        case openingHours = "opening_hours"
        case outdoorSeating = "outdoor_seating"
        case wifi, tobacco
    }
}

typealias PlacesSearch = [PlacesSearchElement]
