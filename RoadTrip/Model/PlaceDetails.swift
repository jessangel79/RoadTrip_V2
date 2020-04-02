//
//  PlaceDetails.swift
//  RoadTrip
//
//  Created by Angelique Babin on 21/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

// MARK: - PlaceDetails

struct PlaceDetails: Decodable {
    let result: ResultDetails
    let status: String

    enum CodingKeys: String, CodingKey {
        case result, status
    }
}

// MARK: - ResultDetails

struct ResultDetails: Decodable {
    let addressComponents: [AddressComponent]?
    let internationalPhoneNumber, name: String?
    let openingHours: OpeningHoursDetails?
    let placeID: String?
    let url: String?
    let website: String?

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case internationalPhoneNumber = "international_phone_number"
        case name
        case openingHours = "opening_hours"
        case placeID = "place_id"
        case url
        case website
    }
}

// MARK: - AddressComponent

struct AddressComponent: Codable {
    let longName: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case types
    }
}

// MARK: - OpeningHoursDetails

struct OpeningHoursDetails: Decodable {
    let weekdayText: [String]

    enum CodingKeys: String, CodingKey {
        case weekdayText = "weekday_text"
    }
}
