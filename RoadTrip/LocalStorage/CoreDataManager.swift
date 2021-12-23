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
    
    func createDetailsTrip(_ parameters: DetailsTrip) {
        let detailsTrip = DetailsTripEntity(context: managedObjectContext)
        detailsTrip.name = parameters.name
        detailsTrip.startDate = parameters.startDate
        detailsTrip.endDate = parameters.endDate
        detailsTrip.numberDays = parameters.numberDays
        detailsTrip.travellers = parameters.travellers
        detailsTrip.notes = parameters.notes
        detailsTrip.imageBackground = parameters.imageBackground
        coreDataStack.saveContext()
    }
    
    func editDetailsTrip(_ parameters: DetailsTrip, index: Int) {
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
    
//    func deleteTraveller(_ travellerName: String) {
//        let request: NSFetchRequest<TravellerEntity> = TravellerEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "name == %@", travellerName)
//        if let entity = try? managedObjectContext.fetch(request) {
//            entity.forEach { managedObjectContext.delete($0) }
//        }
//        coreDataStack.saveContext()
//    }
    
//    func deleteAllTravellers() {
//        travellers.forEach { managedObjectContext.delete($0) }
//        coreDataStack.saveContext()
//    }
    
    // MARK: - Manage ItemEntity
    
    func createItem(_ parameters: Item) {
        let item = ItemEntity(context: managedObjectContext)
        item.id = UUID()
        item.itemName = parameters.itemName
        item.traveller = parameters.traveller
        item.category = parameters.category
        item.itemIsCheck = parameters.itemIsCheck
        item.categoryImage = parameters.categoryImage
        item.imageBackground = parameters.imageBackground
        coreDataStack.saveContext()
    }
    
    func editItem(_ parameters: Item, itemName: String, traveller: String, id: UUID) {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let entity = try? managedObjectContext.fetch(request) {
            if entity.count != 0 {
                for objectUpdate in entity {
                    objectUpdate.setValue(parameters.itemName, forKey: "itemName")
                    objectUpdate.setValue(parameters.traveller, forKey: "traveller")
                    objectUpdate.setValue(parameters.category, forKey: "category")
                    objectUpdate.setValue(parameters.itemIsCheck, forKey: "itemIsCheck")
                    objectUpdate.setValue(parameters.categoryImage, forKey: "categoryImage")
                    objectUpdate.setValue(parameters.imageBackground, forKey: "imageBackground")
                }
            }
        }
        coreDataStack.saveContext()
    }
    
    func deleteItem(id: UUID) {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.includesPropertyValues = false
        if let entity = try? managedObjectContext.fetch(request) {
            entity.forEach { managedObjectContext.delete($0) }
        }
        coreDataStack.saveContext()
    }
    
    func deleteItemsByTraveller(traveller: String) {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "traveller == %@", traveller)
        if let entity = try? managedObjectContext.fetch(request) {
            entity.forEach { managedObjectContext.delete($0) }
        }
        coreDataStack.saveContext()
    }

    func deleteAllItems() {
        items.forEach { managedObjectContext.delete($0) }
        coreDataStack.saveContext()
    }
    
    func checkIfItemExistByTraveller(itemName: String, traveller: String) -> Bool {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "itemName == %@ && traveller == %@", argumentArray: [itemName, traveller])
        guard let counter = try? managedObjectContext.count(for: request) else { return false }
        return counter == 0 ? false : true
    }
    
    func editItemToCheckButton(itemName: String, itemIsCheck: Bool, traveller: String) {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "itemName == %@", itemName)
        request.predicate = NSPredicate(format: "itemName == %@ && traveller == %@", argumentArray: [itemName, traveller])
        if let entity = try? managedObjectContext.fetch(request) {
            let objectUpdate = entity[0] as NSManagedObject
            objectUpdate.setValue(itemIsCheck, forKey: "itemIsCheck")
        }
        coreDataStack.saveContext()
    }
}
