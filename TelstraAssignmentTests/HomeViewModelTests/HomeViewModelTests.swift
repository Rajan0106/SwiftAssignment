//
//  HomeViewModelTests.swift
//  TelstraAssignmentTests
//
//  Created by m-666346 on 01/05/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import XCTest
@testable import TelstraAssignment
class HomeViewModelTest: XCTestCase {
    var aboutCountry: AboutCountry?
    var validNetworkRequestExpectation: XCTestExpectation?
    var inValidNetworkRequestExpectation: XCTestExpectation?
    //System under test
    var homeViewModel: HomeViewModel!
    override func setUp() {
        super.setUp()
        //initializing
        homeViewModel = HomeViewModel()
    }
    override func tearDown() {
        //re-setting
        homeViewModel = nil
        validNetworkRequestExpectation = nil
        inValidNetworkRequestExpectation = nil
        super.tearDown()
    }
    //Network valid call testing
    func testValidNetworkRequest() {
        let mockServer = MockServer()
        mockServer.isTestingForRightURL = true
        homeViewModel.delegate = self
        validNetworkRequestExpectation = expectation(description: "ValidNetworkRequest")
        homeViewModel.fetchAboutCountryDetailFromService(mockServer)
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertNotNil(aboutCountry, "About country should not be nil")
    }
    //Network invalid call testing
    func testInValidNetworkRequest() {
        let mockServer = MockServer()
        mockServer.isTestingForRightURL = false
        homeViewModel.delegate = self
        inValidNetworkRequestExpectation = expectation(description: "InValidNetworkRequest")
        homeViewModel.fetchAboutCountryDetailFromService(mockServer)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(aboutCountry, "About country should  be nil")
    }
    //testing removeInfoFromListIfAllPropertiesAreNil
    func testRemoveInfoFromListIfAllPropertiesAreNil() {
        let mockServer = MockServer()
        let mockData   = mockServer.getMockData()
        homeViewModel.aboutCountry = mockData
        homeViewModel.removeInfoFromListIfAllPropertiesAreNil()
        let message = "There were 14 infolist in mock data in which one has all properties as nil, check mock data"
        XCTAssertTrue(homeViewModel.aboutCountry?.infoList?.count == 13, message)
    }
}
extension HomeViewModelTest: HomeViewModelDelegate {
    func fetched(country: AboutCountry) {
        aboutCountry = country
        validNetworkRequestExpectation?.fulfill()
        validNetworkRequestExpectation = nil
    }
    func fetchCountryDetailFailedWith(error: HTTPErrorCode) {
        aboutCountry = nil
        inValidNetworkRequestExpectation?.fulfill()
        inValidNetworkRequestExpectation = nil
    }
}
