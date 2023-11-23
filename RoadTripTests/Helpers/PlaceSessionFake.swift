//
//  PlaceSessionFake.swift
//  RoadTripTests
//
//  Created by Angelique Babin on 01/04/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation
import Alamofire
@testable import RoadTrip

class PlaceSessionFake: PlaceProtocol {
    
    private let fakeResponse: FakeResponse
    
    init(fakeResponse: FakeResponse) {
        self.fakeResponse = fakeResponse
    }

//    func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void) {
    func request(url: URL, completionHandler: @escaping (AFDataResponse<PlacesSearch>) -> Void) {
//        let httpResponse = fakeResponse.response
//        let data = fakeResponse.data
//        let error = fakeResponse.error
//        let result = Request.serializeResponseJSON(options: .allowFragments, response: httpResponse, data: data, error: error)
//        guard let url = createPlacesSearchUrl(queriesList: [String]()) else { return }
//        let urlRequest = URLRequest(url: url)
//        
//        completionHandler(DataResponse(request: urlRequest, response: httpResponse, data: data, result: result))
        
        AF.request(url).responseDecodable { response in
            completionHandler(response)
        }
    }
    
    private func createPlacesSearchUrl(queriesList: [String]) -> URL? {
        let queriesListUrl = queriesList.joined(separator: "+in+")
        guard let url = URL(string: urlStringApi + queriesListUrl) else { return nil }
        return url
    }
}
