//
//  WaterfallGridViewModelTests.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-02-02.
//


import XCTest
@testable import DogBreedOS

class WaterfallGridViewModelTests: XCTestCase {
    
    var viewModel: WaterfallGridViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = WaterfallGridViewModel(numberOfColumns: 3)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        XCTAssertEqual(viewModel.columns.count, 0, "Columns should be empty after initialization")
        XCTAssertEqual(viewModel.numberOfColumns, 3, "Number of columns should be set correctly during initialization")
    }
    
    // MARK: - Update Card Images List Tests
    
    func testUpdateCardImagesList() {
        let mockImages = [
            CardData(id: "1", name: "Dog1", image: UIImage(named: "testImage1")!),
            CardData(id: "2", name: "Dog2", image: UIImage(named: "testImage2")!),
            CardData(id: "3", name: "Dog3", image: UIImage(named: "testImage3")!),
            CardData(id: "4", name: "Dog4", image: UIImage(named: "testImage4")!)
        ]
        
        viewModel.updateCardImagesList(mockImages)
        
        XCTAssertTrue(viewModel.columns.allSatisfy { !$0.isEmpty }, "All columns should have at least one image")
    }
    
    // MARK: - Published Property Tests
    
    func testPublishedColumnsUpdates() {
        let expectation = self.expectation(description: "Columns updated")
        
        let mockImages = [
            CardData(id: "1", name: "Dog1", image: UIImage(named: "testImage1")!),
            CardData(id: "2", name: "Dog2", image: UIImage(named: "testImage2")!)
        ]
        
        let cancellable = viewModel.$columns.sink { columns in
            if !columns.isEmpty {
                expectation.fulfill()
            }
        }
        
        viewModel.updateCardImagesList(mockImages)
        
        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }
    
    // MARK: - Edge Case Tests
    
    func testEmptyCardImagesList() {
        let emptyImages: [CardData] = []
        
        viewModel.updateCardImagesList(emptyImages)
        
        XCTAssertTrue(viewModel.columns.allSatisfy { $0.isEmpty }, "All columns should be empty when no images are provided")
    }
    
}
