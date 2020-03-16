//
//  CoreDataManager.swift
//  RoadTrip
//
//  Created by Angelique Babin on 07/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {

    // MARK: - Properties

    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext
    
    var places: [PlaceEntity] {
        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
        guard let places = try? managedObjectContext.fetch(request) else { return [] }
        return places
    }
    
    var detailsTrip: [DetailsTripEntity] {
        let request: NSFetchRequest<DetailsTripEntity> = DetailsTripEntity.fetchRequest()
        guard let detailsTrip = try? managedObjectContext.fetch(request) else { return [] }
        return detailsTrip
    }

    // MARK: - Initializer

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }

    // MARK: - Manage Task Entity
    
    func createPlace(parameters: PlaceParameters) {
        let place = PlaceEntity(context: managedObjectContext)
        place.address = parameters.address
        place.icon = parameters.icon
        place.name = parameters.name
        place.openNow = parameters.openNow
        place.photo = parameters.photo
        place.placeID = parameters.placeID
        place.priceLevel = parameters.priceLevel
        place.rating = parameters.rating
        place.types = parameters.types
        place.userRatingsTotal = parameters.userRatingsTotal
        place.country = parameters.country
        place.openDays = parameters.openDays
        place.phoneNumber = parameters.phoneNumber
        place.url = parameters.url
        place.website = parameters.website
        coreDataStack.saveContext()
    }
    
    func deletePlace(placeName: String, address: String) {
        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", placeName)
        request.predicate = NSPredicate(format: "address == %@", address)
        
        if let entity = try? managedObjectContext.fetch(request) {
            entity.forEach { managedObjectContext.delete($0) }
        }
        coreDataStack.saveContext()
    }
    
    func deleteAllPlaces() {
        places.forEach { managedObjectContext.delete($0) }
        coreDataStack.saveContext()
    }

    func checkIfPlaceIsSaved(placeName: String, address: String) -> Bool {
        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", placeName)
        request.predicate = NSPredicate(format: "address == %@", address)
        
        guard let counter = try? managedObjectContext.count(for: request) else { return false }
        return counter == 0 ? false : true
    }
    
    func createDetailsTrip(parameters: DetailsTrip) {
        let detailsTrip = DetailsTripEntity(context: managedObjectContext)
        detailsTrip.name = parameters.name
        detailsTrip.startDate = parameters.startDate
        detailsTrip.endDate = parameters.endDate
        detailsTrip.numberDays = parameters.numberDays
        detailsTrip.travellerOne = parameters.travellerOne
        detailsTrip.travellerTwo = parameters.travellerTwo
        detailsTrip.travellerThree = parameters.travellerThree
        detailsTrip.travellerFour = parameters.travellerFour
        detailsTrip.notes = parameters.notes
        coreDataStack.saveContext()
    }
    
    func deleteDetailsTrip(nameTrip: String, startDate: String, endDate: String) {
        let request: NSFetchRequest<DetailsTripEntity> = DetailsTripEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", nameTrip)
        request.predicate = NSPredicate(format: "startDate == %@", startDate)
        request.predicate = NSPredicate(format: "endDate == %@", endDate)
        
        if let entity = try? managedObjectContext.fetch(request) {
            entity.forEach { managedObjectContext.delete($0) }
        }
        coreDataStack.saveContext()
    }
    
    func deleteAllDetailsTrip() {
        detailsTrip.forEach { managedObjectContext.delete($0) }
        coreDataStack.saveContext()
    }
}
