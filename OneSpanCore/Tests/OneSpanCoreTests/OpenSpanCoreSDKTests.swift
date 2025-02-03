//
//  MockopenSpanCoreInteractor.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-30.
//


import XCTest
@testable import OneSpanCore
import Swinject

final class OpenSpanCoreTests: XCTestCase {
    
    var oneSpanCore: OneSpanCore!
    
    override func setUp() {
        super.setUp()
        oneSpanCore = OneSpanCore.shared
        
        // Initialize the SDK with a valid baseUrl (e.g., a test API endpoint)
        let testBaseUrl = "https://dog.ceo/api/"
        oneSpanCore.initializeSDK(baseUrl: testBaseUrl)
    }
    
    override func tearDown() {
        oneSpanCore.oneSpanCoreInteractor = nil
        
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
        oneSpanCore.initializeSDK(baseUrl: baseUrl)
        
        // Assert
        XCTAssertNotNil(oneSpanCore.oneSpanCoreInteractor, "Expected openSpanCoreInteractor to be initialized")
    }
    
    // Test getBreedList() through OpenSpanCore
    func testGetBreedList() async {
        do {
            // Act
            let breeds = try await oneSpanCore.oneSpanCoreInteractor?.getBreedList()
            
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
        let request = BreedImageInfoRequest(breed: "redbone")
        
        do {
            // Act
            let response = try await oneSpanCore.oneSpanCoreInteractor?.getRandomBreedPhoto(request: request)
            
            // Assert
            XCTAssertNotNil(response, "Expected response to be fetched")
            XCTAssertNotNil(response?.imageUrl, "Expected image URL to be present")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
