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

    // MARK: - Tests Life Cycle

    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }
    
    // MARK: - Helpers
    
    private func createPlace(placeName: String, address: String) {
        coreDataManager.createPlace(parameters: PlaceParameters(
            address: address, country: "France",
            icon: "https://nominatim.openstreetmap.org/images/mapicons/food_pub.p.20.png",
            name: placeName, openDays: "Mo 11:00-00:00; Tu-We 11:00-01:00; Th-Fr 11:00-02:00; Sa 19:00-02:00; Su 19:00-00:00",
            phoneNumber: "+33 1 73 75 86 13", photo: "",
            rating: "0.201", types: "pub",
            website: "http://www.thelionsparis.fr",
            informations: "",
            lat: "49.0318009", lon: "2.061048")
        )
    }
    
    private func createPlaces() {
        createPlace(placeName: "The Lions", address: "Rue du Chevaleret, Quartier de la Gare, Paris, Île-de-France, France métropolitaine, 75013, France")
        createPlace(placeName: "Le Biarritz", address: "Boulevard de Ménilmontant, Paris 11e Arrondissement, Paris, Île-de-France, France métropolitaine, 75011, France")
    }
    
    private func createDetailsTrip(nameTrip: String, travellerOne: String) {
        coreDataManager.createDetailsTrip(parameters: DetailsTrip(
            name: nameTrip,
            startDate: "01/04/2020", endDate: "01/05/2020", numberDays: "30 days",
            travellerOne: travellerOne, travellerTwo: "Fred",
            travellerThree: "Lili", travellerFour: "Charlotte",
            notes: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore.",
            imageBackground: "calanque-de-port-miou-cassis-france_1024x1024.jpg")
        )
    }
    
    private func createDetailsTrips() {
        createDetailsTrip(nameTrip: "Trip to London", travellerOne: "Hugo")
        createDetailsTrip(nameTrip: "Trip to Paris", travellerOne: "Ludo")

    }
    
    private func createItem(itemName: String, category: String, categoryImage: String) {
        coreDataManager.createItem(itemName: itemName,
                                   imageBackground: "lac-en-suisse_1024x1024.jpg",
                                   category: category,
                                   itemIsCheck: false,
                                   categoryImage: categoryImage)
    }
    
    private func createItems() {
        createItem(itemName: "Pull", category: "Clothes", categoryImage: "clothes")
        createItem(itemName: "Switch", category: "Games & Recreation", categoryImage: "games&recreation")
    }
    
    // MARK: - Tests PlaceEntity

    func testAddPlaceMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        createPlace(placeName: "The Lions", address: "Rue du Chevaleret, Quartier de la Gare, Paris, Île-de-France, France métropolitaine, 75013, France")
        XCTAssertTrue(!coreDataManager.places.isEmpty)
        XCTAssertTrue(coreDataManager.places.count == 1)
        XCTAssertTrue(coreDataManager.places[0].address == "Rue du Chevaleret, Quartier de la Gare, Paris, Île-de-France, France métropolitaine, 75013, France")
        XCTAssertTrue(coreDataManager.places[0].country == "France")
        XCTAssertTrue(coreDataManager.places[0].icon == "https://nominatim.openstreetmap.org/images/mapicons/food_pub.p.20.png")
        XCTAssertTrue(coreDataManager.places[0].name == "The Lions")
        XCTAssertTrue(coreDataManager.places[0].openDays == "Mo 11:00-00:00; Tu-We 11:00-01:00; Th-Fr 11:00-02:00; Sa 19:00-02:00; Su 19:00-00:00")
        XCTAssertTrue(coreDataManager.places[0].phoneNumber == "+33 1 73 75 86 13")
        XCTAssertTrue(coreDataManager.places[0].rating == "0.201")
        XCTAssertTrue(coreDataManager.places[0].types?.changeDash.capitalized == "Pub")
        XCTAssertTrue(coreDataManager.places[0].website == "http://www.thelionsparis.fr")
        
        let placeIsSaved = coreDataManager.checkIfPlaceIsSaved(placeName: "The Lions", address: "Rue du Chevaleret, Quartier de la Gare, Paris, Île-de-France, France métropolitaine, 75013, France")
        XCTAssertTrue(coreDataManager.places.count > 0)
        XCTAssertTrue(placeIsSaved)
    }

    func testDeletePlaceMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyDeleted() {
        createPlaces()
        coreDataManager.deletePlace(placeName: "The Lions", address: "Rue du Chevaleret, Quartier de la Gare, Paris, Île-de-France, France métropolitaine, 75013, France")

        let placeIsSavedOne = coreDataManager.checkIfPlaceIsSaved(placeName: "The Lions", address: "Rue du Chevaleret, Quartier de la Gare, Paris, Île-de-France, France métropolitaine, 75013, France")
        XCTAssertFalse(placeIsSavedOne)

        let placeIsSavedTwo = coreDataManager.checkIfPlaceIsSaved(
            placeName: "Le Biarritz", address: "Boulevard de Ménilmontant, Paris 11e Arrondissement, Paris, Île-de-France, France métropolitaine, 75011, France"
        )
        XCTAssertTrue(placeIsSavedTwo)
        XCTAssertFalse(coreDataManager.places.isEmpty)
    }
    
    func testDeleteAllPlacesMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyAllDeleted() {
        createPlaces()
        coreDataManager.deleteAllPlaces()
        XCTAssertTrue(coreDataManager.places.isEmpty)

        let placeIsSavedOne = coreDataManager.checkIfPlaceIsSaved(placeName: "The Lions", address: "Rue du Chevaleret, Quartier de la Gare, Paris, Île-de-France, France métropolitaine, 75013, France")
        XCTAssertFalse(placeIsSavedOne)
        
        let placeIsSavedTwo = coreDataManager.checkIfPlaceIsSaved(
            placeName: "Le Biarritz", address: "Boulevard de Ménilmontant, Paris 11e Arrondissement, Paris, Île-de-France, France métropolitaine, 75011, France"
        )
        XCTAssertFalse(placeIsSavedTwo)
    }
    
    // MARK: - Tests DetailsTripEntity
    
    func testAddDetailsTripMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        createDetailsTrip(nameTrip: "Trip to London", travellerOne: "Hugo")
        XCTAssertTrue(!coreDataManager.detailsTrips.isEmpty)
        XCTAssertTrue(coreDataManager.detailsTrips.count == 1)
        XCTAssertTrue(coreDataManager.detailsTrips[0].name == "Trip to London")
        
        let startDate = coreDataManager.detailsTrips[0].startDate ?? ""
        let endDate = coreDataManager.detailsTrips[0].endDate ?? ""
        XCTAssertTrue(startDate == "01/04/2020")
        XCTAssertTrue(endDate == "01/05/2020")
        XCTAssertTrue(coreDataManager.detailsTrips[0].numberDays == "30 days")
        
        let numberDays = endDate.toDate().timeSinceDateInDays(fromDate: startDate.toDate())
        XCTAssertEqual(numberDays, "30 days")
        
        XCTAssertTrue(coreDataManager.detailsTrips[0].travellerOne == "Hugo")
        XCTAssertTrue(coreDataManager.detailsTrips[0].travellerTwo == "Fred")
        XCTAssertTrue(coreDataManager.detailsTrips[0].travellerThree == "Lili")
        XCTAssertTrue(coreDataManager.detailsTrips[0].travellerFour == "Charlotte")
        XCTAssertTrue(coreDataManager.detailsTrips[0].notes == "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore.")
        XCTAssertTrue(coreDataManager.detailsTrips[0].imageBackground == "calanque-de-port-miou-cassis-france_1024x1024.jpg")
        
        let nameTripOneExist = coreDataManager.checkIfNameTripExist(nameTrip: "Trip to London")
        XCTAssertTrue(coreDataManager.detailsTrips.count > 0)
        XCTAssertTrue(nameTripOneExist)
    }

    func testDeleteDetailsTripMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyDeleted() {
        createDetailsTrips()
        coreDataManager.deleteDetailsTrip(nameTrip: "Trip to London", travellerOne: "Hugo")
        
        let nameTripOneExist =  coreDataManager.checkIfNameTripExist(nameTrip: "Trip to London")
        XCTAssertFalse(nameTripOneExist)
        
        let nameTripTwoExist = coreDataManager.checkIfNameTripExist(nameTrip: "Trip to Paris")
        XCTAssertTrue(nameTripTwoExist)
        XCTAssertFalse(coreDataManager.detailsTrips.isEmpty)
    }
    
    func testDeleteAllDetailsTripMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyAllDeleted() {
        createDetailsTrips()
        coreDataManager.deleteAllDetailsTrip()
        XCTAssertTrue(coreDataManager.detailsTrips.isEmpty)

        let nameTripOneExist = coreDataManager.checkIfNameTripExist(nameTrip: "Trip to London")
        XCTAssertFalse(nameTripOneExist)
        
        let nameTripTwoExist = coreDataManager.checkIfNameTripExist(nameTrip: "Trip to Paris")
        XCTAssertFalse(nameTripTwoExist)
    }
    
    func testEditDetailsTripMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyDeleted() {
        createDetailsTrip(nameTrip: "Trip to London", travellerOne: "Hugo")
        coreDataManager.editDetailsTrip(parameters: DetailsTrip(
            name: "Trip to New York",
            startDate: "01/04/2020", endDate: "01/05/2020", numberDays: "30 days",
            travellerOne: "Tess", travellerTwo: "Fred",
            travellerThree: "Lili", travellerFour: "Charlotte",
            notes: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore.",
            imageBackground: "calanque-de-port-miou-cassis-france_1024x1024.jpg"), index: 0)

        XCTAssertTrue(coreDataManager.detailsTrips[0].name == "Trip to New York")
        XCTAssertTrue(coreDataManager.detailsTrips[0].travellerOne == "Tess")
        
        let nameTripOneOldExist = coreDataManager.checkIfNameTripExist(nameTrip: "Trip to London")
        XCTAssertFalse(nameTripOneOldExist)

        let nameTripOneModifiedExist = coreDataManager.checkIfNameTripExist(nameTrip: "Trip to New York")
        XCTAssertTrue(nameTripOneModifiedExist)
    }

    // MARK: - Tests ItemEntity
    
    func testAddItemMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        createItem(itemName: "Pull", category: "Clothes", categoryImage: "clothes")
        XCTAssertTrue(!coreDataManager.items.isEmpty)
        XCTAssertTrue(coreDataManager.items.count == 1)
        XCTAssertTrue(coreDataManager.items[0].itemName == "Pull")
        XCTAssertTrue(coreDataManager.items[0].imageBackground == "lac-en-suisse_1024x1024.jpg")
        XCTAssertTrue(coreDataManager.items[0].category == "Clothes")
        XCTAssertTrue(coreDataManager.items[0].itemIsCheck == false)
        XCTAssertTrue(coreDataManager.items[0].categoryImage?.deleteWhitespaces == "clothes")
        
        let itemExist = coreDataManager.checkIfItemExist(itemName: "Pull")
        XCTAssertTrue(coreDataManager.items.count > 0)
        XCTAssertTrue(itemExist)
    }

    func testDeleteItemMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyDeleted() {
        createItems()
        coreDataManager.deleteItem(itemName: "Pull")
        
        let itemOneExist = coreDataManager.checkIfItemExist(itemName: "Pull")
        XCTAssertFalse(itemOneExist)
        
        let itemTwoExist = coreDataManager.checkIfItemExist(itemName: "Switch")
        XCTAssertTrue(itemTwoExist)
        XCTAssertFalse(coreDataManager.items.isEmpty)
    }
    
    func testDeleteAllItemsMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyAllDeleted() {
        createItems()
        coreDataManager.deleteAllItems()
        XCTAssertTrue(coreDataManager.items.isEmpty)
        
        let itemExist = coreDataManager.checkIfItemExist(itemName: "Pull")
        XCTAssertFalse(itemExist)
    }
    
    func testEditItemToCheckButtonMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyDeleted() {
        createItems()
        coreDataManager.editItemToCheckButton(itemName: "Pull", itemIsCheck: true)
        XCTAssertTrue(coreDataManager.items[0].itemName == "Pull")
        XCTAssertTrue(coreDataManager.items[0].itemIsCheck == true)
    }
}
