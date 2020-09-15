//
//  RoadTripTests.swift
//  RoadTripTests
//
//  Created by Angelique Babin on 07/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import XCTest
@testable import RoadTrip
import MapKit
import CoreLocation

final class RoadTripTests: XCTestCase {
    
    // MARK: - Properties

    var queriesList: [String]!
    var query: String!
    
    // MARK: - Tests Life Cycle
    
    override func setUp() {
        super.setUp()
        queriesList = ["restaurant", "paris"]
        query = "bar"
    }

    // MARK: - Tests GetPlaces
    
    func testGetPlacesShouldPostFailedCallback() {
        let fakeResponse = FakeResponse(response: nil, data: nil, error: FakeResponseData.networkError)
        let placeSessionFake = PlaceSessionFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPlaces(queriesList: queriesList) { (success, placesSearch) in
            XCTAssertFalse(success)
            XCTAssertNil(placesSearch)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlacesShouldPostFailedCallbackIfNoData() {
        let fakeResponse = FakeResponse(response: nil, data: FakeResponseData.incorrectData, error: nil)
        let placeSessionFake = PlaceSessionFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPlaces(queriesList: queriesList) { (success, placesSearch) in
            XCTAssertFalse(success)
            XCTAssertNil(placesSearch)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlacesShouldPostFailedCallbackIfIncorrectResponse() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctDataPlaces, error: nil)
        let placeSessionFake = PlaceSessionFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPlaces(queriesList: queriesList) { (success, placesSearch) in
            XCTAssertFalse(success)
            XCTAssertNil(placesSearch)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlacesShouldPostFailedCallbackIfResponseCorrectAndDataNil() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: nil, error: nil)
        let placeSessionFake = PlaceSessionFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPlaces(queriesList: queriesList) { (success, placesSearch) in
            XCTAssertFalse(success)
            XCTAssertNil(placesSearch)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlacesShouldPostFailedCallbackIfIncorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData, error: nil)
        let placeSessionFake = PlaceSessionFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPlaces(queriesList: queriesList) { (success, placesSearch) in
            XCTAssertFalse(success)
            XCTAssertNil(placesSearch)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlacesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctDataPlaces, error: nil)
        let placeSessionFake = PlaceSessionFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPlaces(queriesList: queriesList) { (success, placesSearch) in
            XCTAssertTrue(success)
            XCTAssertNotNil(placesSearch)
            XCTAssertEqual(placesSearch?.first?.displayName.cutEndString(), "Harry's Bar")
            XCTAssertEqual(placesSearch?.first?.icon, "https://nominatim.openstreetmap.org/images/mapicons/food_bar.p.20.png")
            XCTAssertEqual(placesSearch?.first?.displayName.cutStartString(2), "5, Rue Daunou, Quartier Gaillon, Paris 2e Arrondissement, Paris, Île-de-France, France métropolitaine, 75002, France")
            XCTAssertEqual(placesSearch?.first?.extratags.openingHours, nil)
            let importance = String(format: "%.1f", placesSearch?.first?.importance ?? 0.0)
            XCTAssertEqual(importance.importanceString(), "6")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - Tests GetPhotos
    
    func testGetPhotosShouldPostFailedCallback() {
        let fakeResponse = FakeResponse(response: nil, data: nil, error: FakeResponseData.networkError)
        let placeSessionPhotosFake = PlaceSessionPhotosFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionPhotosFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPhotos(query: query) { (success, photos) in
            XCTAssertFalse(success)
            XCTAssertNil(photos)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPhotosShouldPostFailedCallbackIfNoData() {
        let fakeResponse = FakeResponse(response: nil, data: FakeResponseData.incorrectData, error: nil)
        let placeSessionPhotosFake = PlaceSessionPhotosFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionPhotosFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPhotos(query: query) { (success, photos) in
            XCTAssertFalse(success)
            XCTAssertNil(photos)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPhotosShouldPostFailedCallbackIfIncorrectResponse() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctDataPhotos, error: nil)
        let placeSessionPhotosFake = PlaceSessionPhotosFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionPhotosFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPhotos(query: query) { (success, photos) in
            XCTAssertFalse(success)
            XCTAssertNil(photos)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPhotosShouldPostFailedCallbackIfResponseCorrectAndDataNil() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: nil, error: nil)
        let placeSessionPhotosFake = PlaceSessionPhotosFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionPhotosFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPhotos(query: query) { (success, photos) in
            XCTAssertFalse(success)
            XCTAssertNil(photos)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPhotosShouldPostFailedCallbackIfIncorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData, error: nil)
        let placeSessionPhotosFake = PlaceSessionPhotosFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionPhotosFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPhotos(query: query) { (success, photos) in
            XCTAssertFalse(success)
            XCTAssertNil(photos)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPhotosShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctDataPhotos, error: nil)
        let placeSessionPhotosFake = PlaceSessionPhotosFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionPhotosFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPhotos(query: query) { (success, photos) in
            XCTAssertTrue(success)
            XCTAssertNotNil(photos)
            XCTAssertEqual(photos?.results.first?.urls.regular, "https://images.unsplash.com/photo-1514933651103-005eec06c04b?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2MjY4MH0")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - Tests Poi - Map
    
    func testInitPoi() {
        let coordinateInit = CLLocationCoordinate2D(latitude: 48.8691942, longitude: 2.3321035)
        let poi = Poi(title: "Harry's Bar",
                      subtitle: "5, Rue Daunou, Quartier Gaillon, Paris 2e Arrondissement, Paris, Île-de-France, France métropolitaine, 75002, France",
                      coordinate: coordinateInit, info: "Bar")
        XCTAssertEqual("Harry's Bar", poi.title)
        XCTAssertEqual("5, Rue Daunou, Quartier Gaillon, Paris 2e Arrondissement, Paris, Île-de-France, France métropolitaine, 75002, France", poi.subtitle)
        XCTAssertEqual("Bar", poi.info)
        XCTAssertEqual(48.8691942, poi.coordinate.latitude)
        XCTAssertEqual(2.3321035, poi.coordinate.longitude)
    }
}
