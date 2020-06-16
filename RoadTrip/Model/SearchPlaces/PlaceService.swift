//
//  PlaceService.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

final class PlaceService {
    
    // MARK: - Vars
    
    private let placeSession: PlaceProtocol
    
    init(placeSession: PlaceProtocol = PlaceSession()) {
        self.placeSession = placeSession
    }
        
    // MARK: - Methods
    
    /// network call to get the places
    func getPlaces(queriesList: [String], completionHandler: @escaping (Bool, PlacesSearch?) -> Void) {
        guard let url = createPlacesSearchUrl(queriesList: queriesList) else { return }
//        print("getPlaces \(url)")
        
        placeSession.request(url: url) { responseData in
            guard responseData.response?.statusCode == 200 else {
                completionHandler(false, nil)
                return
            }
            guard let jsonData = responseData.data else {
                completionHandler(false, nil)
                return
            }
            guard let placesSearch = try? JSONDecoder().decode(PlacesSearch.self, from: jsonData) else {
                completionHandler(false, nil)
                return
            }
            completionHandler(true, placesSearch)
           
        }
    }
    
//    private func createPlacesSearchUrl(queriesList: [String]) -> URL? {
//        let queriesListUrl = queriesList.joined(separator: "+in+")
//        guard let url = URL(string: placeSession.urlStringApi + queriesListUrl) else { return nil }
//        return url
//    }
    
    private func createPlacesSearchUrl(queriesList: [String]) -> URL? {
        let queriesListUrl = queriesList.joined(separator: "+in+")
        guard let url = URL(string: placeSession.urlStringApi + queriesListUrl) else { return nil }
        return url
    }
    
    /// network call to get the details of place
    func getPlaceDetails(placeId: String, completionHandler: @escaping (Bool, PlaceDetails?) -> Void) {
        guard let url = createPlaceDetailsUrl(placeId: placeId) else { return }

        placeSession.request(url: url) { responseData in
            guard responseData.response?.statusCode == 200 else {
                completionHandler(false, nil)
                return
            }
            guard let jsonData = responseData.data else {
                completionHandler(false, nil)
                return
            }
            guard let placesDetails = try? JSONDecoder().decode(PlaceDetails.self, from: jsonData) else {
                completionHandler(false, nil)
                return
            }
            completionHandler(true, placesDetails)
           
        }
    }
    
    private func createPlaceDetailsUrl(placeId: String) -> URL? {
           guard let url = URL(string: placeSession.urlStringDetailsApi + placeId) else { return nil }
           return url
    }
       
}
