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
    
//    var pathDetails: String {
//        return "lookup"
//    }
    
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
    
    /// url  for API to get places
    var urlStringApi: String {
        return "\(scheme)://\(host)/?format=\(format)&\(detailsAdressName)&extratags=\(extratags)&limit=\(limitResults)&q="
    }
    
    var hostPhoto: String {
        return "api.unsplash.com"
    }
    
    var pathDetailsPhoto: String {
        return "/search/photos?"
    }
    
    var keyPhotoApi: String {
        return valueForAPIKey(named: Constants.PhotosAPIKey)
    }
    
    /// url  for API to get photos
    var urlPhotoAPI: String {
        // for test without API unsplash
        return ""
//        return "\(scheme)://\(hostPhoto)\(pathDetailsPhoto)client_id=\(keyPhotoApi)&query="
    }
    
    // Unsplash get image with keyword
    // https://source.unsplash.com/800x450/?hotel
    
    // Search base
//    https://nominatim.openstreetmap.org/?format=json&addressdetails=1&namedetails=1&extratags=1&limit=20&q=bar+in+cergy
    
    // Details of place
//    https://nominatim.openstreetmap.org/lookup?format=json&extratags=1&osm_ids=W102978626
}