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
    var keyPlaceSearch: String {
        return valueForAPIKey(named: Constants.PlacesAPIKey)
    }
    
    var urlStringApi: String {
        return "https://maps.googleapis.com/maps/api/place/textsearch/json?key=\(keyPlaceSearch)&radius=10000&location=49.051111,2.206869&query="
    }

//    var urlStringApi: String {
//        return "https://maps.googleapis.com/maps/api/place/textsearch/json?key=\(keyPlaceSearch)&radius=10000&location=49.051111,2.206869&query="
//    }
    
    var urlStringDetailsApi: String {
        return "https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyDS5dWh8Hii-EiiNfaCucQPi_HDYc4Su2w&fields=place_id,name,address_components,international_phone_number,opening_hours/weekday_text,url,website&place_id="
    }
}
