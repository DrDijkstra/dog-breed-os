//
//  AppContainerTests.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//


import XCTest
import Swinject
import OpenspanCore
@testable import DogBreedOS // Replace with your actual module name

class AppContainerTests: XCTestCase {

    var appContainer: AppContainer!

    override func setUp() {
        super.setUp()
        OpenSpanCore.shared.initializeSDK(baseUrl: "www.google.com")
        appContainer = AppContainer.shared
    }

    override func tearDown() {
        appContainer = nil
        super.tearDown()
    }

    func testOpenSpanCoreServiceRegistration() {
        // Arrange
        let openSpanCoreService = appContainer.resolve(OpenSpanCoreService.self)

        // Assert
        XCTAssertNotNil(openSpanCoreService, "OpenSpanCoreService should be registered and resolvable.")
    }

    func testWaterfallGridViewModelRegistration() {
        // Arrange
        let waterfallGridViewModel = appContainer.resolve(WaterfallGridViewModel.self)

        // Assert
        XCTAssertNotNil(waterfallGridViewModel, "WaterfallGridViewModel should be registered and resolvable.")
    }

    func testDogBreedsViewModelRegistration() {
        // Arrange
        let dogBreedsViewModel = appContainer.resolve(DogBreedsViewModel.self)

        // Assert
        XCTAssertNotNil(dogBreedsViewModel, "DogBreedsViewModel should be registered and resolvable.")
        XCTAssertNotNil(dogBreedsViewModel?.breedImageProvider, "DogBreedsViewModel should have a non-nil BreedImageProvider.")
    }

    func testDependencyResolutionFailure() {
        // Arrange
        let nonRegisteredService = appContainer.resolve(String.self)

        // Assert
        XCTAssertNil(nonRegisteredService, "Non-registered service should return nil.")
    }
}
