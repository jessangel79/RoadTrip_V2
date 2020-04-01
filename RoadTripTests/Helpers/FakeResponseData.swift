//
//  FakeResponseData.swift
//  RoadTripTests
//
//  Created by Angelique Babin on 01/04/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

class FakeResponseData {
    
    // MARK: - Response
    
    static let responseOK = HTTPURLResponse(url: URL(string: "https://www.google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://www.google.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    // MARK: - Error

    class NetworkError: Error {}
    static let networkError = NetworkError()
    
    // MARK: - Data
    
    static var correctDataPlaces: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        guard let url = bundle.url(forResource: "PlacesSearch", withExtension: "json") else {
            fatalError("PlacesSearch.json is not found.")
        }
        guard let data = try? Data(contentsOf: url) else { return Data() }
        return data
    }
    
    static var correctDataPlaceDetails: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        guard let url = bundle.url(forResource: "PlaceDetails", withExtension: "json") else {
            fatalError("PlaceDetails.json is not found.")
        }
        guard let data = try? Data(contentsOf: url) else { return Data() }
        return data
    }
    
    static let incorrectData = "erreur".data(using: .utf8)!
}
