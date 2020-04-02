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
        print("name => \(name)")
        print("icon => \(icon)")
        print("formattedAddress => \(formattedAddress)")
        for types in typesElement {
            print(types)
        }
    }
    
    /// function to debug CoreData for PlaceEntity
    func debugCoreDataPlace(nameDebug: String, coreDataManager: CoreDataManager?) {
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
            print("index : \(index)")
            print("\n")
            index += 1
        }
    }
    
    /// function to debug CoreData for DetailsTripEntity
    func debugCoreDataDetailsTrip(nameDebug: String, coreDataManager: CoreDataManager?) {
        print(nameDebug)
        print("-----------------------")
        var index = 0
        for detailsTrip in coreDataManager?.detailsTrips ?? [DetailsTripEntity]() {
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
            print("imageBackground : \(detailsTrip.imageBackground ?? "imageBackground error")")
            print("\n")
            index += 1
        }
    }
    
    /// function to debug CoreData for ItemEntity
    func debugCoreDataItem(nameDebug: String, coreDataManager: CoreDataManager?) {
        print(nameDebug)
        print("-----------------------")
        var index = 0
        for item in coreDataManager?.items ?? [ItemEntity]() {
            print("Item N° \(index + 1) :")
            print("itemName : \(item.itemName ?? "itemName error")")
            print("imageBackground : \(item.imageBackground ?? "imageBackground error")")
            print("category : \(item.category ?? "category error")")
            print("itemIsCheck : \(item.itemIsCheck)")
            print("categoryImage : \(item.categoryImage ?? "categoryImage error")")
            print("\n")
            index += 1
        }
    }
    
    /// function to debug if cellule is selected and check the index of cellule selected
    func debugCellule(celluleActive: Bool, celluleIndex: Int?) {
        print("celluleActive : \(celluleActive)")
        print("celluleIndex : \(String(describing: celluleIndex))")
    }

}
