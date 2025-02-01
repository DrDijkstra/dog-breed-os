//
//  MemoryCacheTests.swift
//  OpenspanCore
//
//  Created by Sanjay Dey on 2025-01-31.
//


import XCTest
@testable import OpenspanCore
import UIKit

final class MemoryCacheTests: XCTestCase {
    var memoryCache: MemoryCache!

    override func setUp() {
        super.setUp()
        memoryCache = MemoryCache()
    }

    override func tearDown() {
        memoryCache.clearCache()
        memoryCache = nil
        super.tearDown()
    }

    func testCacheImage() {
        let testImage = UIImage(systemName: "star")!
        let key = "testKey"

        memoryCache.cacheImage(testImage, forKey: key)
        let cachedImage = memoryCache.getImage(forKey: key)

        XCTAssertNotNil(cachedImage, "Cached image should not be nil")
        XCTAssertEqual(cachedImage, testImage, "Cached image should be the same as the stored image")
    }

    func testClearCache() {
        let testImage = UIImage(systemName: "star")!
        let key = "testKey"

        memoryCache.cacheImage(testImage, forKey: key)
        memoryCache.clearCache()

        let cachedImage = memoryCache.getImage(forKey: key)
        XCTAssertNil(cachedImage, "Cache should be empty after clearing")
    }
}
