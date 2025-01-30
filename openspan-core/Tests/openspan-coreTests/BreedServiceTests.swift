//
//  BreedServiceTests.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//


//
//  BreedServiceTests.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//

import XCTest
@testable import openspan_core

final class BreedServiceTests: XCTestCase {
    var breedService: BreedServiceImpl!
    var mockApiService: MockApiService!
    
    override func setUp() {
        super.setUp()
        mockApiService = MockApiService()
        breedService = BreedServiceImpl(apiService: mockApiService)
    }
    
    override func tearDown() {
        breedService = nil
        mockApiService = nil
        super.tearDown()
    }
    
    // MARK: - getBreedList Tests
    
    func testGetBreedList_Success() async {
        // Given
        let expectedBreeds = [
            BreedInfo(name: "hound", subBreeds: ["afghan", "basset"]),
            BreedInfo(name: "bulldog", subBreeds: ["boston", "english"])
        ]
        mockApiService.getBreedListResult = .success(ApiBreedData(
            message: ["hound": ["afghan", "basset"], "bulldog": ["boston", "english"]],
            status: "success"
        ))
        
        // When
        do {
            let breeds = try await breedService.getBreedList()
            
            // Then
            XCTAssertEqual(breeds, expectedBreeds)
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }
    
    func testGetBreedList_Failure() async {
        // Given
        let networkError = NetworkError(NSError(domain: "Network", code: -1009, userInfo: nil))
        mockApiService.getBreedListResult = .failure(ApiError.networkError(networkError))
        
        // When
        do {
            _ = try await breedService.getBreedList()
            XCTFail("Expected error, but got success")
        } catch {
            // Then
            XCTAssertEqual(error as? ApiError, ApiError.networkError(networkError))
        }
    }
    
    // MARK: - getRandomBreedPhoto Tests
    
    func testGetRandomBreedPhoto_Success() async {
        // Given
        let expectedResponse = BreedImageInfoResponse(imageUrl: "https://example.com/dog.jpg")
        mockApiService.getRandomBreedPhotoResult = .success(
            ApiRandomBreedImageResponse(message: "https://example.com/dog.jpg", status: "success")
        )
        
        // When
        do {
            let response = try await breedService.getRandomBreedPhoto(request: BreedImageInfoRequest(breed: "hound"))
            
            // Then
            XCTAssertEqual(response, expectedResponse)
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }
    
    func testGetRandomBreedPhoto_InvalidRequest() async {
        // Given
        let request = BreedImageInfoRequest(breed: nil)
        
        // When
        do {
            _ = try await breedService.getRandomBreedPhoto(request: request)
            XCTFail("Expected error, but got success")
        } catch let error as ApiError {
            // Then
            XCTAssertEqual(error, ApiError.invalidRequest("Breed name is required"))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testGetRandomBreedPhoto_Failure() async {
        // Given
        let networkError = NetworkError(NSError(domain: "Network", code: -1009, userInfo: nil))
        mockApiService.getRandomBreedPhotoResult = .failure(ApiError.networkError(networkError))
        
        // When
        do {
            _ = try await breedService.getRandomBreedPhoto(request: BreedImageInfoRequest(breed: "hound"))
            XCTFail("Expected error, but got success")
        } catch {
            // Then
            XCTAssertEqual(error as? ApiError, ApiError.networkError(networkError))
        }
    }
}

// MARK: - MockApiService

final class MockApiService: ApiService {
    var getBreedListResult: Result<ApiBreedData, Error> = .success(ApiBreedData(message: [:], status: "success"))
    var getRandomBreedPhotoResult: Result<ApiRandomBreedImageResponse, Error> = .success(
        ApiRandomBreedImageResponse(message: "https://example.com/dog.jpg", status: "success")
    )
    
    func getBreedList() async throws -> ApiBreedData {
        switch getBreedListResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    func getRandomBreedPhoto(request: ApiRandomBreedImageRequest) async throws -> ApiRandomBreedImageResponse {
        switch getRandomBreedPhotoResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
