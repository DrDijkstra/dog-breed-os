//
//  AppContainerTests.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//


import XCTest
import Swinject
import OpenspanCore
@testable import DogBreedOS

class AppContainerTests: XCTestCase {
    
    var appContainer: AppContainer!
    
    override func setUp() {
        super.setUp()
        appContainer = AppContainer.shared
    }
    
    override func tearDown() {
        appContainer = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testResolveOpenSpanCoreService() {
        let service: OpenSpanCoreInteractor? = appContainer.resolve(OpenSpanCoreInteractor.self)
        XCTAssertNotNil(service, "OpenSpanCoreService should be resolved successfully.")
    }
    
    func testResolveWaterfallGridViewModel() {
        let viewModel: WaterfallGridViewModel? = appContainer.resolve(WaterfallGridViewModel.self)
        XCTAssertNotNil(viewModel, "WaterfallGridViewModel should be resolved successfully.")
    }
    
    func testResolveCardImageProvider() {
        let cardImageProvider: CardImageProvider? = appContainer.resolve(CardImageProvider.self)
        XCTAssertNotNil(cardImageProvider, "CardImageProvider should be resolved successfully.")
    }
    
    func testResolveDogBreedsViewModel() {
        let viewModel: DogBreedsViewModel? = appContainer.resolve(DogBreedsViewModel.self)
        XCTAssertNotNil(viewModel, "DogBreedsViewModel should be resolved successfully.")
    }
    
    func testResolveDependenciesInDogBreedsViewModel() {
        let viewModel: DogBreedsViewModel? = appContainer.resolve(DogBreedsViewModel.self)
        XCTAssertNotNil(viewModel?.interactor, "OpenSpanCoreInteractor should be injected into DogBreedsViewModel.")
        XCTAssertNotNil(viewModel?.breedImageProvider, "CardImageProvider should be injected into DogBreedsViewModel.")
    }
}
