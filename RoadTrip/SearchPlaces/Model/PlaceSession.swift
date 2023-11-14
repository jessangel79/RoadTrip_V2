//
//  PlaceSession.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation
import Alamofire

class PlaceSession: PlaceProtocol {
    func request(url: URL, completionHandler: @escaping (AFDataResponse<PlacesSearch>) -> Void) {
        AF.request(url).responseDecodable(of: PlacesSearch.self) { response in
            completionHandler(response)
        }
    }
//    func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void) {
//        Alamofire.request(url).responseJSON { responseData in
//            completionHandler(responseData)
//        }
//    }
}
