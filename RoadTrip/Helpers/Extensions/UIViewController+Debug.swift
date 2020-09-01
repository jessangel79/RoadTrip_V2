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
    
    func debugGetPlaces(nameDebug: String, placesList: [PlacesSearchElement]) {
        print("type : \(placesList[0].type)")
        print("displayName : \(placesList[0].displayName)")
        print("extratags : \(placesList[0].extratags)")
        print("phone : \(String(describing: placesList[0].extratags.phone))")
        print("website : \(String(describing: placesList[0].extratags.website))")
        
        print("address : \(placesList[0].address)")
        print("boundingbox : \(placesList[0].boundingbox)")
        print("icon : \(placesList[0].icon)")
        print("importance : \(placesList[0].importance)")
        print("licence : \(placesList[0].licence)")
        print("namedetails : \(placesList[0].namedetails)")
        print("osmID : \(placesList[0].osmID)")
        print("osmType : \(placesList[0].osmType)")
        print("placeID : \(placesList[0].placeID)")
        
//        var index = 0
//        for place in placesList {
//            print("Place N° \(index + 1) :")
//            print("Address : \(place.address)")
//            print("Type : \(place.type)")
//            print("Name : \(place.displayName)")
//            index += 1
//        }
    }
}
