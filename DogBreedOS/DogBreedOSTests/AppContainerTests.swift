//
//  AppContainerTests.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//


import XCTest
import Swinject
import OpenspanCore
@testable import DogBreedOS // Replace with your app's module name

class AppContainerTests: XCTestCase {
    
    var appContainer: AppContainer!
    
    override func setUp() {
        super.setUp()
        // Initialize the container
        appContainer = AppContainer.shared
    }
    
    override func tearDown() {
        // Cleanup
        appContainer = nil
        super.tearDown()
    }
    
    func testResolveOpenSpanCoreService() {
        let service: OpenSpanCoreService? = appContainer.resolve(OpenSpanCoreService.self)
        XCTAssertNotNil(service, "OpenSpanCoreService should be resolved successfully.")
    }
    
    func testResolveWaterfallGridViewModel() {
        let viewModel: WaterfallGridViewModel? = appContainer.resolve(WaterfallGridViewModel.self)
        XCTAssertNotNil(viewModel, "WaterfallGridViewModel should be resolved successfully.")
        //XCTAssertEqual(viewModel?.numberOfColumns, 2, "WaterfallGridViewModel should have 2 columns.")
    }
    
    func testResolveCardImageProvider() {
        let cardImageProvider: CardImageProvider? = appContainer.resolve(CardImageProvider.self)
        XCTAssertNotNil(cardImageProvider, "CardImageProvider should be resolved successfully.")
    }
    
    func testResolveDogBreedsViewModel() {
        let viewModel: DogBreedsViewModel? = appContainer.resolve(DogBreedsViewModel.self)
        XCTAssertNotNil(viewModel, "DogBreedsViewModel should be resolved successfully.")
    }
    
    // Optionally, test any additional logic in the resolve method, e.g., checking if all dependencies are injected correctly
    func testResolveDependenciesInDogBreedsViewModel() {
        let viewModel: DogBreedsViewModel? = appContainer.resolve(DogBreedsViewModel.self)
        let openSpanCoreService = viewModel?.openSpanCoreService
        let cardImageProvider = viewModel?.breedImageProvider
        
        XCTAssertNotNil(openSpanCoreService, "OpenSpanCoreService should be injected into DogBreedsViewModel.")
        XCTAssertNotNil(cardImageProvider, "CardImageProvider should be injected into DogBreedsViewModel.")
    }
}
