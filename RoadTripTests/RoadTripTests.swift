//
//  RoadTripTests.swift
//  RoadTripTests
//
//  Created by Angelique Babin on 07/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import XCTest
@testable import RoadTrip

class RoadTripTests: XCTestCase {
    
    // MARK: - Properties

    var queriesList: [String]!
    var placeId: String!
    
    // MARK: - Tests Life Cycle
    
    override func setUp() {
        super.setUp()
        queriesList = ["restaurant", "paris"]
        placeId = "ChIJqTQzIehv5kcRaF3hD1SzX5A"
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
            XCTAssertEqual(placesSearch?.results[0].name, "Le Cinq")
            XCTAssertEqual(placesSearch?.results[0].icon, "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png")
            XCTAssertEqual(placesSearch?.results[0].formattedAddress, "31 Avenue George V, 75008 Paris, France")
            XCTAssertEqual(placesSearch?.results[0].placeID, "ChIJqTQzIehv5kcRaF3hD1SzX5A")
            XCTAssertEqual(placesSearch?.results[0].priceLevel, 4)
            XCTAssertEqual(placesSearch?.results[0].openingHours?.openNow, false)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - Tests GetPlaceDetails
    
    func testGetPlaceDetailsShouldPostFailedCallback() {
        let fakeResponse = FakeResponse(response: nil, data: nil, error: FakeResponseData.networkError)
        let placeSessionDetailsFake = PlaceSessionDetailsFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionDetailsFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPlaceDetails(placeId: placeId) { (success, placesDetails) in
            XCTAssertFalse(success)
            XCTAssertNil(placesDetails)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlaceDetailsShouldPostFailedCallbackIfNoData() {
        let fakeResponse = FakeResponse(response: nil, data: FakeResponseData.incorrectData, error: nil)
        let placeSessionDetailsFake = PlaceSessionDetailsFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionDetailsFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPlaceDetails(placeId: placeId) { (success, placesDetails) in
            XCTAssertFalse(success)
            XCTAssertNil(placesDetails)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlaceDetailsShouldPostFailedCallbackIfIncorrectResponse() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctDataPlaceDetails, error: nil)
        let placeSessionDetailsFake = PlaceSessionDetailsFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionDetailsFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPlaceDetails(placeId: placeId) { (success, placesDetails) in
            XCTAssertFalse(success)
            XCTAssertNil(placesDetails)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlaceDetailsShouldPostFailedCallbackIfResponseCorrectAndDataNil() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: nil, error: nil)
        let placeSessionDetailsFake = PlaceSessionDetailsFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionDetailsFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPlaceDetails(placeId: placeId) { (success, placesDetails) in
            XCTAssertFalse(success)
            XCTAssertNil(placesDetails)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlaceDetailsShouldPostFailedCallbackIfIncorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData, error: nil)
        let placeSessionDetailsFake = PlaceSessionDetailsFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionDetailsFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPlaceDetails(placeId: placeId) { (success, placesDetails) in
            XCTAssertFalse(success)
            XCTAssertNil(placesDetails)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlaceDetailsShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctDataPlaceDetails, error: nil)
        let placeSessionDetailsFake = PlaceSessionDetailsFake(fakeResponse: fakeResponse)
        let placeService = PlaceService(placeSession: placeSessionDetailsFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeService.getPlaceDetails(placeId: placeId) { (success, placesDetails) in
            XCTAssertTrue(success)
            XCTAssertNotNil(placesDetails)
            XCTAssertEqual(placesDetails?.result.name, "Le Cinq")
            XCTAssertEqual(placesDetails?.result.url, "https://maps.google.com/?cid=10403230837874187624")
            XCTAssertEqual(placesDetails?.result.website, "http://www.restaurant-lecinq.com/?seo=google_local_par2_emea")
            XCTAssertEqual(placesDetails?.result.openingHours?.weekdayText, nil)
            XCTAssertEqual(placesDetails?.result.internationalPhoneNumber, "+33 1 49 52 71 54")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

}
