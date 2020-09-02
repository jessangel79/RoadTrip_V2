//
//  PlaceProtocol.swift
//  RoadTrip
//
//  Created by Angelique Babin on 07/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation
import Alamofire

protocol PlaceProtocol {
    var urlStringApi: String { get }
    func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void)
}

extension PlaceProtocol {
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "nominatim.openstreetmap.org"
    }
    
    var pathDetails: String {
        return "lookup"
    }
    
    var format: String {
        return "json"
    }
    
    var detailsAdressName: String {
        return "addressdetails=1&namedetails=1"
    }
    
    var extratags: String {
        return "1"
    }
    
    var limitResults: String {
        return "20"
    }
    
    var urlStringApi: String {
        return "\(scheme)://\(host)/?format=\(format)&\(detailsAdressName)&extratags=\(extratags)&limit=\(limitResults)&q="
    }

    var urlStringDetailsApi: String {
        return "\(scheme)://\(host)/\(pathDetails)\(pathDetails)?format=\(format)&extratags=\(extratags)&osm_ids="
    }
    
    // 800x600
    var urlStringImage: String {
        return "https://source.unsplash.com/800x600/?"
    }
    
    // API unsplash
    var urlBasePhotoAPI: String {
        return "https://api.unsplash.com/search/photos?"
    }
    
    var urlPhotoAPI: String {
        return "\(urlBasePhotoAPI)client_id=\(keyPhotoApi)&query="
    }
    
    var keyPhotoApi: String {
        return valueForAPIKey(named: Constants.PhotosAPIKey)
    }

    // Unsplash get image with keyword
    // https://source.unsplash.com/800x450/?hotel
    
    // Search base
//    https://nominatim.openstreetmap.org/?format=json&addressdetails=1&namedetails=1&extratags=1&limit=20&q=bar+in+cergy
    
    // Details of place
//    https://nominatim.openstreetmap.org/lookup?format=json&extratags=1&osm_ids=W102978626
}

//extension PlaceProtocol {
//
//    var scheme: String {
//        return "https"
//    }
//
//    var host: String {
//        return "maps.googleapis.com"
//    }
//
//    var pathTextsearch: String {
//        return "maps/api/place/textsearch/json"
//    }
//
//    var pathDetails: String {
//        return "maps/api/place/details/json"
//    }
//    var keyPlaceSearch: String {
//        return valueForAPIKey(named: Constants.PlacesAPIKey)
//    }
//
//    var radius: String {
//        return "10000"
//    }
//
//    var location: String {
//        return "49.051111,2.206869"
//    }
//
//    var fields: String {
//        return "place_id,name,address_components,international_phone_number,opening_hours/weekday_text,url,website"
//    }
//
//    var urlStringApi: String {
//        return "\(scheme)://\(host)/\(pathTextsearch)?key=\(keyPlaceSearch)&radius=\(radius)&location=\(location)&query="
//    }
//
//    var urlStringDetailsApi: String {
//        return "\(scheme)://\(host)/\(pathDetails)?key=\(keyPlaceSearch)&fields=\(fields)&place_id="
//    }

//    // "https://maps.googleapis.com/maps/api/place/textsearch/json?key=\(keyPlaceSearch)&radius=10000&location=49.051111,2.206869&query="
//    // "https://maps.googleapis.com/maps/api/place/details/json?key=\(keyPlaceSearch)&fields=place_id,name,address_components,international_phone_number,opening_hours/weekday_text,url,website&place_id="
//}
