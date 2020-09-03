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
//    let osmType: OsmType
    let osmID: Int
    let boundingbox: [String]
    let lat, lon, displayName: String
//    let placesSearchClass: Class
//    let type: TypeEnum
    let type: String
    let importance: Double
    let icon: String
    let address: Address
    let extratags: Extratags
    let namedetails: Namedetails

    enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
        case licence
        case osmType = "osm_type"
        case osmID = "osm_id"
        case boundingbox, lat, lon
        case displayName = "display_name"
//        case placesSearchClass = "class"
        case type, importance, icon, address, extratags, namedetails
    }
}

// MARK: - Address

struct Address: Decodable {
    let amenity: String?
    let road: String
    let neighbourhood, suburb, town: String?
//    let municipality: Municipality
//    let county: County
//    let state: State
    let country: String
    let postcode: String
//    let countryCode: CountryCode
    let houseNumber, industrial, village, hamlet: String?

    enum CodingKeys: String, CodingKey {
        case amenity, road, neighbourhood, suburb, town
//        case municipality, county, state
        case country
        case postcode
//        case countryCode = "country_code"
        case houseNumber = "house_number"
        case industrial, village, hamlet
    }
}

//enum Country: String, Decodable {
//    case france = "France"
//}

//
//enum CountryCode: String, Decodable {
//    case fr = "fr"
//}
//
//enum County: String, Decodable {
//    case valDOise = "Val-d'Oise"
//}
//
//enum Municipality: String, Decodable {
//    case pontoise = "Pontoise"
//}
//
//enum State: String, Decodable {
//    case îleDeFrance = "Île-de-France"
//}

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

// MARK: - Namedetails

struct Namedetails: Decodable {
    let name: String?
}

//enum OsmType: String, Decodable {
//    case node
//    case way
////    case node = "node"
////    case way = "way"
//}

//enum Class: String, Decodable {
//    case amenity
////    case amenity = "amenity"
//}

//enum TypeEnum: String, Decodable {
//    case bar
//    case pub
////    case bar = "bar"
////    case pub = "pub"
//}

typealias PlacesSearch = [PlacesSearchElement]

// MARK: - API Google Place ID
// MARK: - PlacesSearch

//struct PlacesSearch: Decodable {
//    let results: [Result]
//    let status: String
//
//    enum CodingKeys: String, CodingKey {
//        case results, status
//    }
//}

// MARK: - Result

//struct Result: Decodable {
//    let formattedAddress: String
//    let icon: String?
//    let id, name: String
//    let photos: [Photo]?
//    let placeID: String
//    let priceLevel: Int?
//    let rating: Double
//    let types: [String]
//    let userRatingsTotal: Int?
//    let openingHours: OpeningHours?
//
//    enum CodingKeys: String, CodingKey {
//        case formattedAddress = "formatted_address"
//        case icon, id, name, photos
//        case placeID = "place_id"
//        case priceLevel = "price_level"
//        case rating
//        case types
//        case userRatingsTotal = "user_ratings_total"
//        case openingHours = "opening_hours"
//    }
//}

// MARK: - OpeningHours

//struct OpeningHours: Decodable {
//    let openNow: Bool?
//
//    enum CodingKeys: String, CodingKey {
//        case openNow = "open_now"
//    }
//}

// MARK: - Photo

//struct Photo: Decodable {
//    let height: Int
//    let htmlAttributions: [String]
//    let photoReference: String
//    let width: Int
//
//    enum CodingKeys: String, CodingKey {
//        case height
//        case htmlAttributions = "html_attributions"
//        case photoReference = "photo_reference"
//        case width
//    }
//}
