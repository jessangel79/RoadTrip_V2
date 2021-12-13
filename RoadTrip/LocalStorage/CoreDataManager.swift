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
    
    var detailsTrips: [DetailsTripEntity] {
        let request: NSFetchRequest<DetailsTripEntity> = DetailsTripEntity.fetchRequest()
        guard let detailsTrip = try? managedObjectContext.fetch(request) else { return [] }
        return detailsTrip
    }
    
    var items: [ItemEntity] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "category", ascending: true),
            NSSortDescriptor(key: "itemName", ascending: true)
        ]
        guard let item = try? managedObjectContext.fetch(request) else { return [] }
        return item
    }
    
    var travellers: [TravellerEntity] {
        let request: NSFetchRequest<TravellerEntity> = TravellerEntity.fetchRequest()
        guard let traveller = try? managedObjectContext.fetch(request) else { return [] }
        return traveller
    }

    // MARK: - Initializer

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }

    // MARK: - Manage PlaceEntity
    
    func createPlace(parameters: PlaceParameters) {
        let place = PlaceEntity(context: managedObjectContext)
        place.address = parameters.address
        place.icon = parameters.icon
        place.name = parameters.name
        place.photo = parameters.photo
        place.rating = parameters.rating
        place.types = parameters.types
        place.country = parameters.country
        place.openDays = parameters.openDays
        place.phoneNumber = parameters.phoneNumber
        place.website = parameters.website
        place.informations = parameters.informations
        place.lat = parameters.lat
        place.lon = parameters.lon
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
        
    // MARK: - Manage DetailsTripEntity
    
    func createDetailsTrip(parameters: DetailsTrip) {
        let detailsTrip = DetailsTripEntity(context: managedObjectContext)
        detailsTrip.name = parameters.name
        detailsTrip.startDate = parameters.startDate
        detailsTrip.endDate = parameters.endDate
        detailsTrip.numberDays = parameters.numberDays
//        let travellers = parameters.travellers.joined(separator: "-")
        detailsTrip.travellers = parameters.travellers

//        detailsTrip.travellerOne = parameters.travellerOne
//        detailsTrip.travellerTwo = parameters.travellerTwo
//        detailsTrip.travellerThree = parameters.travellerThree
//        detailsTrip.travellerFour = parameters.travellerFour
        detailsTrip.notes = parameters.notes
        detailsTrip.imageBackground = parameters.imageBackground
        coreDataStack.saveContext()
    }
    
    func deleteDetailsTrip(nameTrip: String) {
        let request: NSFetchRequest<DetailsTripEntity> = DetailsTripEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", nameTrip)
        
        if let entity = try? managedObjectContext.fetch(request) {
            entity.forEach { managedObjectContext.delete($0) }
        }
        coreDataStack.saveContext()
    }
    
    func deleteAllDetailsTrip() {
        detailsTrips.forEach { managedObjectContext.delete($0) }
        coreDataStack.saveContext()
    }
    
    func checkIfNameTripExist(nameTrip: String) -> Bool {
        let request: NSFetchRequest<DetailsTripEntity> = DetailsTripEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", nameTrip)
        
        guard let counter = try? managedObjectContext.count(for: request) else { return false }
        return counter == 0 ? false : true
    }
        
    func editDetailsTrip(parameters: DetailsTrip, index: Int) {
        let request: NSFetchRequest<DetailsTripEntity> = DetailsTripEntity.fetchRequest()
        if let entity = try? managedObjectContext.fetch(request) {
            let objectUpdate = entity[index] as NSManagedObject
            objectUpdate.setValue(parameters.name, forKey: "name")
            objectUpdate.setValue(parameters.startDate, forKey: "startDate")
            objectUpdate.setValue(parameters.endDate, forKey: "endDate")
            objectUpdate.setValue(parameters.numberDays, forKey: "numberDays")
            objectUpdate.setValue(parameters.travellers, forKey: "travellers")
            objectUpdate.setValue(parameters.notes, forKey: "notes")
        }
        coreDataStack.saveContext()
    }
    
    // MARK: - Manage TravellerEntity
    
    func createTraveller(_ travellerName: String) {
        let traveller = TravellerEntity(context: managedObjectContext)
        traveller.name = travellerName
        coreDataStack.saveContext()
    }
    
    func editTraveller(_ travellerName: String, index: Int) {
        let request: NSFetchRequest<TravellerEntity> = TravellerEntity.fetchRequest()
        if let entity = try? managedObjectContext.fetch(request) {
            let objectUpdate = entity[index] as NSManagedObject
            objectUpdate.setValue(travellerName, forKey: "name")
        }
        coreDataStack.saveContext()
    }
    
    func deleteTraveller(_ travellerName: String) {
        let request: NSFetchRequest<TravellerEntity> = TravellerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", travellerName)
        if let entity = try? managedObjectContext.fetch(request) {
            entity.forEach { managedObjectContext.delete($0) }
        }
        coreDataStack.saveContext()
    }
    
    func deleteAllTravellers() {
        travellers.forEach { managedObjectContext.delete($0) }
        coreDataStack.saveContext()
    }
    
    // MARK: - Manage ItemEntity
    
    func createItem(itemName: String, imageBackground: String, category: String, itemIsCheck: Bool, categoryImage: String) {
        let item = ItemEntity(context: managedObjectContext)
        item.itemName = itemName
        item.imageBackground = imageBackground
        item.category = category
        item.itemIsCheck = itemIsCheck
        item.categoryImage = categoryImage
        coreDataStack.saveContext()
    }
    
    func deleteItem(itemName: String) {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "itemName == %@", itemName)

        if let entity = try? managedObjectContext.fetch(request) {
            entity.forEach { managedObjectContext.delete($0) }
        }
        coreDataStack.saveContext()
    }
    
    func deleteAllItems() {
        items.forEach { managedObjectContext.delete($0) }
        coreDataStack.saveContext()
    }
    
    func checkIfItemExist(itemName: String) -> Bool {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "itemName == %@", itemName)
        
        guard let counter = try? managedObjectContext.count(for: request) else { return false }
        return counter == 0 ? false : true
    }
    
    func editItemToCheckButton(itemName: String, itemIsCheck: Bool) {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "itemName == %@", itemName)
        if let entity = try? managedObjectContext.fetch(request) {
            let objectUpdate = entity[0] as NSManagedObject
            objectUpdate.setValue(itemIsCheck, forKey: "itemIsCheck")
        }
        coreDataStack.saveContext()
    }
}
