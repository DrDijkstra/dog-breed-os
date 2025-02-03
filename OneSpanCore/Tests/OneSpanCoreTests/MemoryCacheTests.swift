//
//  MemoryCacheTests.swift
//  OpenspanCore
//
//  Created by Sanjay Dey on 2025-01-31.
//

import XCTest
@testable import OneSpanCore
import UIKit

final class MemoryCacheTests: XCTestCase {
    var memoryCache: MemoryCacheRepository!

    override func setUp() {
        super.setUp()
        memoryCache = MemoryCacheRepositoryImpl()
    }

    override func tearDown() {
        memoryCache = nil
        super.tearDown()
    }

    func testCacheImage() async {
        // Given
        let testImage = UIImage(systemName: "star")!
        let key = "testKey"

        // When: Cache the image
        await memoryCache.cacheImage(testImage, forKey: key)

        // Then: Retrieve the cached image
        if let cachedImage = await memoryCache.getImage(forKey: key) {
            XCTAssertNotNil(cachedImage, "Cached image should not be nil")
            XCTAssertEqual(cachedImage, testImage, "Cached image should be the same as the stored image")
        } else {
            XCTFail("Cached image is nil")
        }
    }

    func testClearCache() async {
        // Given
        let testImage = UIImage(systemName: "star")!
        let key = "testKey"

        // When: Cache the image
        await memoryCache.cacheImage(testImage, forKey: key)

        // Then: Clear the cache and check if image is removed
        await memoryCache.clearCache()

        let cachedImage = await memoryCache.getImage(forKey: key)
        XCTAssertNil(cachedImage, "Cache should be empty after clearing")
    }
}
