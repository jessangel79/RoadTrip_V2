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
        print("getPlaces \(url)")
        
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
    
    private func createPlacesSearchUrl(queriesList: [String]) -> URL? {
        let queriesListUrl = queriesList.joined(separator: "+in+")
        guard let url = URL(string: placeSession.urlStringApi + queriesListUrl) else { return nil }
        return url
    }
    
    /// network call to get photos with unsplash API
    func getPhotos(query: String, completionHandler: @escaping (Bool, Photos?) -> Void) {
        guard let url = createPhotosUrl(query: query) else { return }
        print("getPhotos \(url)")

        placeSession.request(url: url) { responseData in
            guard responseData.response?.statusCode == 200 else {
                completionHandler(false, nil)
                return
            }
            guard let jsonData = responseData.data else {
                completionHandler(false, nil)
                return
            }
            guard let photos = try? JSONDecoder().decode(Photos.self, from: jsonData) else {
                completionHandler(false, nil)
                return
            }
            completionHandler(true, photos)
        }
    }
    
    private func createPhotosUrl(query: String) -> URL? {
        guard let url = URL(string: placeSession.urlPhotoAPI + query) else { return nil }
        return url
    }
}
