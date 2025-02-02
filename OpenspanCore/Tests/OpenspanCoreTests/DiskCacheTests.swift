//
//  DiskCacheTests.swift
//  OpenspanCore
//
//  Created by Sanjay Dey on 2025-01-31.
//


import XCTest
@testable import OpenspanCore
import UIKit

final class DiskCacheTests: XCTestCase {
    var diskCache: DiskCacheRepository!
    let testCacheDirectory = "TestDiskCache"

    override func setUp() {
        super.setUp()
        diskCache = DiskCacheRepositoryImpl() // Assuming no need for `cacheDirectoryString` parameter anymore.
    }

    override func tearDown() {
        let expectation = self.expectation(description: "Clear Cache Expectation")
        
        // Perform async cleanup inside Task
        Task {
            await diskCache.clearCache() // Perform async operation
            expectation.fulfill() // Fulfill the expectation once async operation completes
        }
        
        // Wait for the async operation to complete within the given timeout
        wait(for: [expectation], timeout: 5.0)
        
        diskCache = nil
        super.tearDown()
    }

    func testCacheImage() async {
        let bundle = Bundle.module
        guard let testImage = UIImage(named: "Hello_World", in: bundle, compatibleWith: nil) else {
            XCTFail("Image not found")
            return
        }
        let key = "testKey"

        // Cache image
        await diskCache.cacheImage(testImage, forKey: key)

        // Retrieve the cached image
        if let cachedImage = await diskCache.getImage(forKey: key) {
            XCTAssertTrue(Utlis.areImagesAlmostSame(testImage, cachedImage, tolerance: 0.01),
                          "Cached image should be visually similar to the stored image")
        } else {
            XCTFail("Cached image should not be nil")
        }
    }

    func testRetrieveNonexistentImage() async {
        let cachedImage = await diskCache.getImage(forKey: "nonExistentKey")
        XCTAssertNil(cachedImage, "Should return nil for a non-existent key")
    }

    func testClearCache() async {
        let testImage = UIImage(systemName: "star")!
        let key = "testKey"

        // Cache an image
        await diskCache.cacheImage(testImage, forKey: key)

        // Clear the cache
        await diskCache.clearCache()

        // Try to retrieve the image after clearing the cache
        let cachedImage = await diskCache.getImage(forKey: key)
        XCTAssertNil(cachedImage, "Cache should be empty after clearing")
    }
}
