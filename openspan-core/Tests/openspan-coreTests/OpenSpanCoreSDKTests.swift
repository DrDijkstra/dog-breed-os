//
//  MockOpenSpanCoreService.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-30.
//


import XCTest
@testable import openspan_core
import Swinject

final class OpenSpanCoreTests: XCTestCase {
    
    var openSpanCore: OpenSpanCore!
    
    override func setUp() {
        super.setUp()
        openSpanCore = OpenSpanCore.shared
        
        // Initialize the SDK with a valid baseUrl (e.g., a test API endpoint)
        let testBaseUrl = "https://dog.ceo/api/" // Replace with a valid test API URL
        openSpanCore.initializeSDK(baseUrl: testBaseUrl)
    }
    
    override func tearDown() {
        openSpanCore.openSpanCoreService = nil
        
        // Reset the SDKContainer to its original state
        SDKContainer.shared.container.removeAll()
        SDKContainer.shared.injectDependency(baseUrl: "") // Reinitialize with empty baseUrl
        super.tearDown()
    }
    
    // Test SDK initialization
    func testInitializeSDK() {
        // Arrange
        let baseUrl = "https://api.example.com"
        
        // Act
        openSpanCore.initializeSDK(baseUrl: baseUrl)
        
        // Assert
        XCTAssertNotNil(openSpanCore.openSpanCoreService, "Expected OpenSpanCoreService to be initialized")
    }
    
    // Test getBreedList() through OpenSpanCore
    func testGetBreedList() async {
        do {
            // Act
            let breeds = try await openSpanCore.openSpanCoreService?.getBreedList()
            
            // Assert
            XCTAssertNotNil(breeds, "Expected breeds to be fetched")
            XCTAssertFalse(breeds?.isEmpty ?? true, "Expected breeds list to not be empty")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // Test getRandomBreedPhoto() through OpenSpanCore
    func testGetRandomBreedPhoto() async {
        // Arrange
        let request = BreedImageInfoRequest(breed: "redbone") // Replace with a valid breed name
        
        do {
            // Act
            let response = try await openSpanCore.openSpanCoreService?.getRandomBreedPhoto(request: request)
            
            // Assert
            XCTAssertNotNil(response, "Expected response to be fetched")
            XCTAssertNotNil(response?.imageUrl, "Expected image URL to be present")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
