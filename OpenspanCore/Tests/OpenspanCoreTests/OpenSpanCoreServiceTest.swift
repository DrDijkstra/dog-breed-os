//
//  MockBreedService.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-30.
//


import XCTest
@testable import OpenspanCore

final class OpenSpanCoreServiceImplTests: XCTestCase {
    
    var openSpanCoreService: OpenSpanCoreServiceImpl!
    var mockBreedService: MockBreedService!
    
    override func setUp() {
        super.setUp()
        mockBreedService = MockBreedService()
        openSpanCoreService = OpenSpanCoreServiceImpl(breedService: mockBreedService)
    }
    
    override func tearDown() {
        openSpanCoreService = nil
        mockBreedService = nil
        super.tearDown()
    }
    
    // Test getBreedList() success case
    func testGetBreedList_Success() async {
        // Arrange
        let expectedBreeds = [
            BreedInfo(name: "Breed1", subBreeds: ["SubBreed1"]),
            BreedInfo(name: "Breed2", subBreeds: nil)
        ]
        mockBreedService.getBreedListResult = .success(expectedBreeds)
        
        do {
            // Act
            let breeds = try await openSpanCoreService.getBreedList()
            
            // Assert
            XCTAssertEqual(breeds, expectedBreeds, "Expected breeds to match mock data")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // Test getBreedList() failure case
    func testGetBreedList_Failure() async {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockBreedService.getBreedListResult = .failure(expectedError)
        
        do {
            // Act
            _ = try await openSpanCoreService.getBreedList()
            
            // Assert
            XCTFail("Expected an error to be thrown")
        } catch {
            // Assert
            XCTAssertEqual(error as NSError, expectedError, "Expected error to match mock error")
        }
    }
    
    // Test getRandomBreedPhoto() success case
    func testGetRandomBreedPhoto_Success() async {
        // Arrange
        let expectedResponse = BreedImageInfoResponse(imageUrl: "https://example.com/image.jpg")
        mockBreedService.getRandomBreedPhotoResult = .success(expectedResponse)
        let request = BreedImageInfoRequest(breed: "Breed1")
        
        do {
            // Act
            let response = try await openSpanCoreService.getRandomBreedPhoto(request: request)
            
            // Assert
            XCTAssertEqual(response, expectedResponse, "Expected response to match mock data")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // Test getRandomBreedPhoto() failure case
    func testGetRandomBreedPhoto_Failure() async {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockBreedService.getRandomBreedPhotoResult = .failure(expectedError)
        let request = BreedImageInfoRequest(breed: "Breed1")
        
        do {
            // Act
            _ = try await openSpanCoreService.getRandomBreedPhoto(request: request)
            
            // Assert
            XCTFail("Expected an error to be thrown")
        } catch {
            // Assert
            XCTAssertEqual(error as NSError, expectedError, "Expected error to match mock error")
        }
    }
}


// Mock BreedService for testing
class MockBreedService: BreedService {
    var getBreedListResult: Result<[BreedInfo], Error> = .success([])
    var getRandomBreedPhotoResult: Result<BreedImageInfoResponse, Error> = .success(BreedImageInfoResponse(imageUrl: nil))
    
    func getBreedList() async throws -> [BreedInfo] {
        switch getBreedListResult {
        case .success(let breeds):
            return breeds
        case .failure(let error):
            throw error
        }
    }
    
    func getRandomBreedPhoto(request: BreedImageInfoRequest) async throws -> BreedImageInfoResponse {
        switch getRandomBreedPhotoResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
