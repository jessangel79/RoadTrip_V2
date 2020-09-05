//
//  PlaceSessionDetailsFake.swift
//  RoadTripTests
//
//  Created by Angelique Babin on 01/04/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation
import Alamofire
@testable import RoadTrip

//class PlaceSessionDetailsFake: PlaceProtocol {
//    
//    private let fakeResponse: FakeResponse
//    
//    init(fakeResponse: FakeResponse) {
//        self.fakeResponse = fakeResponse
//    }
//
//    func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void) {
//        let httpResponse = fakeResponse.response
//        let data = fakeResponse.data
//        let error = fakeResponse.error
//        let result = Request.serializeResponseJSON(options: .allowFragments, response: httpResponse, data: data, error: error)
//        
//        guard let url = createPlaceDetailsUrl(placeId: String()) else { return }
//        let urlRequest = URLRequest(url: url)
//        
//        completionHandler(DataResponse(request: urlRequest, response: httpResponse, data: data, result: result))
//    }
//    
//    private func createPlaceDetailsUrl(placeId: String) -> URL? {
//           guard let url = URL(string: urlStringDetailsApi + placeId) else { return nil }
//           return url
//    }
//    
//}
