//
//  ApiServiceTests.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//


import XCTest
import Alamofire
@testable import OpenspanCore

final class ApiServiceTests: XCTestCase {

    var apiService: ApiServiceImpl!
    var mockSession: Session!

    override func setUp() {
        super.setUp()
        
        // Create a mock session with a custom URLSessionConfiguration
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = Session(configuration: configuration)
        
        // Initialize ApiServiceImpl with the mock session
        apiService = ApiServiceImpl(baseUrl: "https://mock.api.com", timeoutInterval: 10)
        apiService.session = mockSession // Inject the mock session
    }

    override func tearDown() {
        apiService = nil
        mockSession = nil
        super.tearDown()
    }

    // MARK: - Test Cases

    func testGetBreedList_Success() async throws {
        // Mock response data
        let mockData = """
        {
            "message": {
                "breed1": [],
                "breed2": ["subBreed1", "subBreed2"]
            },
            "status": "success"
        }
        """.data(using: .utf8)!
        
        // Set up mock response
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockData)
        }
        
        // Execute the request
        let breedData = try await apiService.getBreedList()
        
        // Validate the response
        XCTAssertEqual(breedData.status, "success")
        XCTAssertEqual(breedData.message!.count, 2)
        XCTAssertTrue(breedData.message!.keys.contains("breed1"))
        XCTAssertTrue(breedData.message!.keys.contains("breed2"))
    }

    func testGetRandomBreedPhoto_Success() async throws {
        // Mock response data
        let mockData = """
        {
            "message": "https://example.com/dog.jpg",
            "status": "success"
        }
        """.data(using: .utf8)!
        
        // Set up mock response
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockData)
        }
        
        // Execute the request
        let request = ApiRandomBreedImageRequest(breed: "hound")
        let photoResponse = try await apiService.getRandomBreedPhoto(request: request)
        
        // Validate the response
        XCTAssertEqual(photoResponse.status, "success")
        XCTAssertEqual(photoResponse.message, "https://example.com/dog.jpg")
    }

    func testGetBreedList_Failure() async {
        // Set up mock error
        MockURLProtocol.requestHandler = { request in
            throw AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 500))
        }
        
        // Execute the request and expect an error
        do {
            _ = try await apiService.getBreedList()
            XCTFail("Expected an error but got a successful response.")
        } catch {
            XCTAssertTrue(error is AFError)
        }
    }
}

// MARK: - Mock URLProtocol

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("No request handler provided.")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
