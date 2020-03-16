//
//  UIViewController+Debug.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

// MARK: - Extension to debug

extension UIViewController {
    /// function to debug Get Places
    func debugGetPlaces(_ placesSearch: PlacesSearch, _ placesList: [Result], _ photosList: [String], _ placeIDsList: [String]) {
        let name = placesSearch.results[0].name
        let formattedAddress = placesSearch.results[0].formattedAddress
        let typesElement = placesSearch.results[0].types
        guard let icon = placesSearch.results[0].icon else { return }
        print("Name => \(name)")
        print("formattedAddress => \(formattedAddress)")
        for types in typesElement {
            print(types)
        }
        print("icon => \(icon)")
//        print("ARRAY placesList in SearchVC : \(placesList)")
        print("COUNT placesList in SearchVC : \(placesList.count)")
        print("COUNT photosList in SearchVC  : \(photosList.count)")
        print("COUNT placeIDsList in SearchVC : \(placeIDsList.count)")
//        print("array placeIDsList in SearchVC : \(placeIDsList)")
    }
    
    /// function to debug List Places
    func debugListPlaces(_ placesList: [Result], _ photosList: [String], _ placeIDsList: [String], _ placeDetailsResultsList: [ResultDetails]) {
        print("COUNT placesList in ListPlaces : \(placesList.count)")
//        print("ARRAY placesList in ListPlaces : \(placesList)")
        print("COUNT photosList in ListPlaces : \(photosList.count)")
//        print("ARRAY photosList in ListPlaces : \(photosList)")
        print("COUNT placeIDsList in ListPlaces : \(placeIDsList.count)")
        print("COUNT placeDetailsResultsList in ListPlaces : \(placeDetailsResultsList.count)")
//        print("ARRAY placeDetailsResultsList in ListPlaces : \(placeDetailsResultsList)")
    }
    
    /// function to debug Place Details
    func debugPlaceDetails(_ placeDetailsResultsList: [ResultDetails]) {
//        print("cellule in PlaceDetails => \(String(describing: cellule))")
//        print("photoOfCellule in PlaceDetails => \(String(describing: photoOfCellule))")
//        print("placeIdCellule in PlaceDetails => \(String(describing: placeIdCellule))")
        print("COUNT placeDetailsResultsList in PlaceDetails : \(placeDetailsResultsList.count)")
//        print("ARRAY placeDetailsResultsList in PlaceDetails : \(placeDetailsResultsList)")
    }
    
    /// function to debug CoreData
    func debugCoreDataPlace(nameDebug: String, coreDataManager: CoreDataManager?) {
        // priceLevel: Int16, rating: Double, types: String, userRatingTotal: Int16
        print(nameDebug)
        print("-----------------------")
        var index = 0
        for place in coreDataManager?.places ?? [PlaceEntity]() {
            print("Place N° \(index + 1) :")
            print("Address : \(place.address ?? "address error")")
            print("Icon : \(place.icon ?? "icon error")")
            print("Name : \(place.name ?? "name error")")
            print("OpenNow : \(place.openNow)")
            print("Photo : \(place.photo ?? "photo error")")
            print("PlaceID : \(place.placeID ?? "placeID error")")
            print("PriceLevel : \(place.priceLevel)")
            print("Rating : \(place.rating)")
            print("Types : \(place.types ?? "types error")")
            print("UserRatingsTotal : \(place.userRatingsTotal)")
            print("Country : \(place.country ?? "country error")")
            print("OpenDays : \(place.openDays ?? "openDays error")")
            print("PhoneNumber : \(place.phoneNumber ?? "phoneNumber error")")
            print("Url : \(place.url ?? "url error")")
            print("Website : \(place.website ?? "website error")")
            print("\n")
            index += 1
        }
    }
    
    func debugCoreDataDetailsTrip(nameDebug: String, coreDataManager: CoreDataManager?) {
        // priceLevel: Int16, rating: Double, types: String, userRatingTotal: Int16
        print(nameDebug)
        print("-----------------------")
        var index = 0
        for detailsTrip in coreDataManager?.detailsTrip ?? [DetailsTripEntity]() {
            print("Trip N° \(index + 1) :")
            print("name : \(detailsTrip.name ?? "name error")")
            print("startDate : \(detailsTrip.startDate ?? "startDate error")")
            print("endDate : \(detailsTrip.endDate ?? "endDate error")")
            print("numberDays : \(detailsTrip.numberDays ?? "numberDays error")")
            print("travellerOne : \(detailsTrip.travellerOne ?? "travellerOne error")")
            print("travellerTwo : \(detailsTrip.travellerTwo ?? "travellerTwo error")")
            print("travellerThree : \(detailsTrip.travellerThree ?? "travellerThree error")")
            print("travellerFour : \(detailsTrip.travellerFour ?? "travellerFour error")")
            print("notes : \(detailsTrip.notes ?? "notes error")")
            print("\n")
            index += 1
        }
    }
}
