//
//  DataManager.swift
//  RoadTrip
//
//  Created by Angelique Babin on 29/09/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

final class DataManager {
        
    func savePlace(cellule: PlacesSearchElement?, photoOfCellule: String?, informations: inout String?, coreDataManager: CoreDataManager?) {
        let address = cellule?.displayName.cutStartString(2) ?? ""
        let icon = cellule?.icon ?? ""
        let name = cellule?.displayName.cutEndString() ?? ""
        let photo = photoOfCellule ?? ""
        let importance = String(format: "%.1f", cellule?.importance ?? 0.0)
        let rating = importance.importanceString() ?? ""
        let types =  cellule?.type.changeDash.capitalized ?? "N/A"
        let country = cellule?.address.country ?? ""
        let openDays = setOpeningHours(openingHours: cellule?.extratags.openingHours)
        let phoneNumber = cellule?.extratags.phone ?? "N/A"
        let website = cellule?.extratags.website ?? "N/A"
        let informations = informations ?? ""
        let lat = cellule?.lat ?? ""
        let lon = cellule?.lon ?? ""
        coreDataManager?.createPlace(parameters: PlaceParameters(address: address, country: country, icon: icon, name: name,
                                                                 openDays: openDays, phoneNumber: phoneNumber, photo: photo,
                                                                 rating: rating, types: types, website: website, informations: informations,
                                                                 lat: lat, lon: lon))
    }
    
    func setOpeningHours(openingHours: String?) -> String {
        var openDays = ""
        if let openingHours = openingHours {
            openDays = openingHours
        } else {
            openDays = "Opening Hours : N/A"
        }
        return openDays
    }
}
