//
//  CoreDataManagerTests.swift
//  RoadTripTests
//
//  Created by Angelique Babin on 01/04/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import XCTest
@testable import RoadTrip

final class CoreDataManagerTests: XCTestCase {
    
    // MARK: - Properties

    var coreDataStack: MockCoreDataStack!
    var coreDataManager: CoreDataManager!
    
    var addressOne: String!
    var addressTwo: String!
    var country: String!
    var icon: String!
    var namePlaceOne: String!
    var namePlaceTwo: String!
    var openDays: String!
    var openNow: Bool!
    var phoneNumber: String!
    var photo1: String!
    var photo2: String!
    var placeID: String!
    var priceLevel: Int16!
    var rating: Double!
    var types: String!
    var url: String!
    var userRatingsTotal: Int64!
    var website: String!
    var placeParametersOne: PlaceParameters!
    var placeParametersTwo: PlaceParameters!
    
    var nameTripOne: String!
    var nameTripTwo: String!
    var startDate: String!
    var endDate: String!
    var numberDays: String!
    var travellerOne1: String!
    var travellerOne2: String!
    var travellerTwo: String!
    var travellerThree: String!
    var travellerFour: String!
    var notes: String!
    var imageBackground: String!
    var detailsTripParametersOne: DetailsTrip!
    var detailsTripParametersTwo: DetailsTrip!
    var nameTripOneModified: String!
    var travellerOne1Modified: String!
    var detailsTripParametersOneModified: DetailsTrip!

    // MARK: - Tests Life Cycle

    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
        
        addressOne = "31 Avenue George V, 75008 Paris, France"
        addressTwo = "38 Rue de Cîteaux, 75012 Paris, France"
        country = "France"
        icon = "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png"
        namePlaceOne = "Le Cinq"
        namePlaceTwo = "Madito"
        openDays = "N/A"
        openNow = false
        phoneNumber = "+33 1 49 52 71 54"
        photo1 = "CmRaAAAAHjEA-RRj0dXJZ2DgwXbBiYcZsy4Se0T0RVeQeh3xvLf-ZqXryGRmyFBt-jTMf5Quh_7b-xnkV19kWXuHWtxf-"
        photo2 = "wtF8evJgBg70-IVpU0k9ibnCIvMelUZdqOnfIMPQ_0bEhC8tZdh67WkRNswK1UfFifsGhRIvJUMJqWFZwhKv6buotnJz0WFNw"
        placeID = "ChIJqTQzIehv5kcRaF3hD1SzX5A"
        priceLevel = 4
        rating = 4.6
        types = "Bar, Restaurant, Food, Point Of Interest, Establishment"
        url = "https://maps.google.com/?cid=10403230837874187624"
        userRatingsTotal = 1107
        website = "http://www.restaurant-lecinq.com/?seo=google_local_par2_emea"
        placeParametersOne = PlaceParameters(address: addressOne, country: country, icon: icon,
                                             name: namePlaceOne, openDays: openDays, openNow: openNow,
                                             phoneNumber: phoneNumber, photo: photo1 + photo2,
                                             placeID: placeID, priceLevel: priceLevel, rating: rating,
                                             types: types, url: url, userRatingsTotal: userRatingsTotal,
                                             website: website)
        placeParametersTwo = PlaceParameters(address: addressTwo, country: country, icon: icon,
                                             name: namePlaceTwo, openDays: openDays, openNow: openNow,
                                             phoneNumber: phoneNumber, photo: photo1 + photo2,
                                             placeID: placeID, priceLevel: priceLevel, rating: rating,
                                             types: types, url: url, userRatingsTotal: userRatingsTotal,
                                             website: website)
        
        nameTripOne = "Trip to London"
        nameTripTwo = "Trip to Paris"
        startDate = "01/04/2020"
        endDate = "01/05/2020"
        numberDays = "30 days"
        travellerOne1 = "Hugo"
        travellerOne2 = "Ludo"
        travellerTwo = "Fred"
        travellerThree = "Lili"
        travellerFour = "Charlotte"
        notes = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore."
        imageBackground = "calanque-de-port-miou-cassis-france_1024x1024.jpg"
        detailsTripParametersOne = DetailsTrip(name: nameTripOne,
                                               startDate: startDate, endDate: endDate,
                                               numberDays: numberDays,
                                               travellerOne: travellerOne1, travellerTwo: travellerTwo,
                                               travellerThree: travellerThree, travellerFour: travellerFour,
                                               notes: notes, imageBackground: imageBackground)
        detailsTripParametersTwo = DetailsTrip(name: nameTripTwo,
                                               startDate: startDate, endDate: endDate,
                                               numberDays: numberDays,
                                               travellerOne: travellerOne2, travellerTwo: travellerTwo,
                                               travellerThree: travellerThree, travellerFour: travellerFour,
                                               notes: notes, imageBackground: imageBackground)
        nameTripOneModified = "Trip to New York"
        travellerOne1Modified = "Tess"
        detailsTripParametersOneModified = DetailsTrip(name: nameTripOneModified,
                                                       startDate: startDate, endDate: endDate,
                                                       numberDays: numberDays,
                                                       travellerOne: travellerOne1Modified, travellerTwo: travellerTwo,
                                                       travellerThree: travellerThree, travellerFour: travellerFour,
                                                       notes: notes, imageBackground: imageBackground)
    }

    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }

    // MARK: - Tests PlaceEntity

    func testAddPlaceMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        coreDataManager.createPlace(parameters: placeParametersOne)
        XCTAssertTrue(!coreDataManager.places.isEmpty)
        XCTAssertTrue(coreDataManager.places.count == 1)
        XCTAssertTrue(coreDataManager.places[0].address == addressOne)
        XCTAssertTrue(coreDataManager.places[0].country == country)
        XCTAssertTrue(coreDataManager.places[0].icon == icon)
        XCTAssertTrue(coreDataManager.places[0].openDays == openDays)
        XCTAssertTrue(coreDataManager.places[0].openNow == openNow)
        XCTAssertTrue(coreDataManager.places[0].photo == photo1 + photo2)
        XCTAssertTrue(coreDataManager.places[0].placeID == placeID)
        XCTAssertTrue(coreDataManager.places[0].priceLevel == priceLevel)
        XCTAssertTrue(coreDataManager.places[0].rating == rating)
        XCTAssertTrue(coreDataManager.places[0].types == types)
        XCTAssertTrue(coreDataManager.places[0].url == url)
        XCTAssertTrue(coreDataManager.places[0].userRatingsTotal == userRatingsTotal)
        XCTAssertTrue(coreDataManager.places[0].website == website)
        
        let placeIsSaved = coreDataManager.checkIfPlaceIsSaved(placeName: namePlaceOne, address: addressOne)
        XCTAssertTrue(coreDataManager.places.count > 0)
        XCTAssertTrue(placeIsSaved)
    }

    func testDeletePlaceMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyDeleted() {
        coreDataManager.createPlace(parameters: placeParametersOne)
        coreDataManager.createPlace(parameters: placeParametersTwo)
        coreDataManager.deletePlace(placeName: namePlaceOne, address: addressOne)
        
        let placeIsSavedOne = coreDataManager.checkIfPlaceIsSaved(placeName: namePlaceOne, address: addressOne)
        XCTAssertFalse(placeIsSavedOne)
        
        let placeIsSavedTwo = coreDataManager.checkIfPlaceIsSaved(placeName: namePlaceTwo, address: addressTwo)
        XCTAssertTrue(placeIsSavedTwo)
        XCTAssertFalse(coreDataManager.places.isEmpty)
    }
    
    func testDeleteAllPlacesMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyAllDeleted() {
        coreDataManager.createPlace(parameters: placeParametersOne)
        coreDataManager.deleteAllPlaces()
        XCTAssertTrue(coreDataManager.places.isEmpty)
        
        let placeIsSaved = coreDataManager.checkIfPlaceIsSaved(placeName: namePlaceOne, address: addressOne)
        XCTAssertFalse(placeIsSaved)
    }
    
    // MARK: - Tests DetailsTripEntity
    
    func testAddDetailsTripMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        coreDataManager.createDetailsTrip(parameters: detailsTripParametersOne)
        XCTAssertTrue(!coreDataManager.detailsTrip.isEmpty)
        XCTAssertTrue(coreDataManager.detailsTrip.count == 1)
        XCTAssertTrue(coreDataManager.detailsTrip[0].name == nameTripOne)
        XCTAssertTrue(coreDataManager.detailsTrip[0].startDate == startDate)
        XCTAssertTrue(coreDataManager.detailsTrip[0].endDate == endDate)
        XCTAssertTrue(coreDataManager.detailsTrip[0].numberDays == numberDays)
        XCTAssertTrue(coreDataManager.detailsTrip[0].travellerOne == travellerOne1)
        XCTAssertTrue(coreDataManager.detailsTrip[0].travellerTwo == travellerTwo)
        XCTAssertTrue(coreDataManager.detailsTrip[0].travellerThree == travellerThree)
        XCTAssertTrue(coreDataManager.detailsTrip[0].travellerFour == travellerFour)
        XCTAssertTrue(coreDataManager.detailsTrip[0].notes == notes)
        XCTAssertTrue(coreDataManager.detailsTrip[0].imageBackground == imageBackground)
        
        let nameTripOneExist = coreDataManager.checkIfNameTripExist(nameTrip: nameTripOne)
        XCTAssertTrue(coreDataManager.detailsTrip.count > 0)
        XCTAssertTrue(nameTripOneExist)
    }

    func testDeleteDetailsTripMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyDeleted() {
        coreDataManager.createDetailsTrip(parameters: detailsTripParametersOne)
        coreDataManager.createDetailsTrip(parameters: detailsTripParametersTwo)
        coreDataManager.deleteDetailsTrip(nameTrip: nameTripOne, travellerOne: travellerOne1)
        
        let nameTripOneExist =  coreDataManager.checkIfNameTripExist(nameTrip: nameTripOne)
        XCTAssertFalse(nameTripOneExist)
        
        let nameTripTwoExist = coreDataManager.checkIfNameTripExist(nameTrip: nameTripTwo)
        XCTAssertTrue(nameTripTwoExist)
        XCTAssertFalse(coreDataManager.detailsTrip.isEmpty)
    }
    
    func testDeleteAllDetailsTripMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyAllDeleted() {
        coreDataManager.createDetailsTrip(parameters: detailsTripParametersOne)
        coreDataManager.deleteAllDetailsTrip()
        XCTAssertTrue(coreDataManager.detailsTrip.isEmpty)
        
        let nameTripOneExist = coreDataManager.checkIfNameTripExist(nameTrip: nameTripOne)
        XCTAssertFalse(nameTripOneExist)
    }
    
    func testEditDetailsTripMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyDeleted() {
        coreDataManager.createDetailsTrip(parameters: detailsTripParametersOne)
        coreDataManager.editDetailsTrip(parameters: detailsTripParametersOneModified, index: 0)
        
        XCTAssertTrue(coreDataManager.detailsTrip[0].name == nameTripOneModified)
        XCTAssertTrue(coreDataManager.detailsTrip[0].travellerOne == travellerOne1Modified)
        
        let nameTripOneOldExist = coreDataManager.checkIfNameTripExist(nameTrip: nameTripOne)
        XCTAssertFalse(nameTripOneOldExist)
        
        let nameTripOneModifiedExist = coreDataManager.checkIfNameTripExist(nameTrip: nameTripOneModified)
        XCTAssertTrue(nameTripOneModifiedExist)
    }

    // MARK: - Tests ItemEntity
    
    func testAddItemMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        coreDataManager.createItem(itemName: "Pull",
                                   imageBackground: "lac-en-suisse_1024x1024.jpg",
                                   category: "Clothes",
                                   itemIsCheck: false,
                                   categoryImage: "clothes")
        XCTAssertTrue(!coreDataManager.item.isEmpty)
        XCTAssertTrue(coreDataManager.item.count == 1)
        XCTAssertTrue(coreDataManager.item[0].itemName == "Pull")
        XCTAssertTrue(coreDataManager.item[0].imageBackground == "lac-en-suisse_1024x1024.jpg")
        XCTAssertTrue(coreDataManager.item[0].category == "Clothes")
        XCTAssertTrue(coreDataManager.item[0].itemIsCheck == false)
        XCTAssertTrue(coreDataManager.item[0].categoryImage == "clothes")
        
        let itemExist = coreDataManager.checkIfItemExist(itemName: "Pull")
        XCTAssertTrue(coreDataManager.item.count > 0)
        XCTAssertTrue(itemExist)
    }

    func testDeleteItemMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyDeleted() {
        coreDataManager.createItem(itemName: "Pull",
                                   imageBackground: "lac-en-suisse_1024x1024.jpg",
                                   category: "Clothes",
                                   itemIsCheck: false,
                                   categoryImage: "clothes")
        coreDataManager.createItem(itemName: "Switch",
                                   imageBackground: "italie-paysage_1024x1024.jpg",
                                   category: "Games & Recreation",
                                   itemIsCheck: false,
                                   categoryImage: "games&recreation")
        coreDataManager.deleteItem(itemName: "Pull")
        
        let itemOneExist = coreDataManager.checkIfItemExist(itemName: "Pull")
        XCTAssertFalse(itemOneExist)
        
        let itemTwoExist = coreDataManager.checkIfItemExist(itemName: "Switch")
        XCTAssertTrue(itemTwoExist)
        XCTAssertFalse(coreDataManager.item.isEmpty)
    }
    
    func testDeleteAllItemsMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyAllDeleted() {
        coreDataManager.createItem(itemName: "Pull",
                                   imageBackground: "lac-en-suisse_1024x1024.jpg",
                                   category: "Clothes",
                                   itemIsCheck: false,
                                   categoryImage: "clothes")
        coreDataManager.deleteAllItems()
        XCTAssertTrue(coreDataManager.item.isEmpty)
        
        let itemExist = coreDataManager.checkIfItemExist(itemName: "Pull")
        XCTAssertFalse(itemExist)
    }
    
    func testEditItemToCheckButtonMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyDeleted() {
        coreDataManager.createItem(itemName: "Pull",
                                   imageBackground: "lac-en-suisse_1024x1024.jpg",
                                   category: "Clothes",
                                   itemIsCheck: false,
                                   categoryImage: "clothes")
        coreDataManager.editItemToCheckButton(itemName: "Pull", itemIsCheck: true)
        XCTAssertTrue(coreDataManager.item[0].itemName == "Pull")
        XCTAssertTrue(coreDataManager.item[0].itemIsCheck == true)
    }
}
