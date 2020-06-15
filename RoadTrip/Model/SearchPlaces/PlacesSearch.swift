//
//  PlacesSearch.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

// MARK: - PlacesSearch

struct PlacesSearch: Decodable {
    let results: [Result]
    let status: String

    enum CodingKeys: String, CodingKey {
        case results, status
    }
}

// MARK: - Result

struct Result: Decodable {
    let formattedAddress: String
    let icon: String?
    let id, name: String
    let photos: [Photo]?
    let placeID: String
    let priceLevel: Int?
    let rating: Double
    let types: [String]
    let userRatingsTotal: Int?
    let openingHours: OpeningHours?

    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
        case icon, id, name, photos
        case placeID = "place_id"
        case priceLevel = "price_level"
        case rating
        case types
        case userRatingsTotal = "user_ratings_total"
        case openingHours = "opening_hours"
    }
}

// MARK: - OpeningHours

struct OpeningHours: Decodable {
    let openNow: Bool?

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

// MARK: - Photo

struct Photo: Decodable {
    let height: Int
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case height
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width
    }
}
