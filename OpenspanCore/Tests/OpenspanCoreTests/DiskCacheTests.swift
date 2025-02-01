//
//  DiskCacheTests.swift
//  OpenspanCore
//
//  Created by Sanjay Dey on 2025-01-31.
//


import XCTest
@testable import OpenspanCore
import UIKit
import CoreImage

final class DiskCacheTests: XCTestCase {
    var diskCache: DiskCacheService!
    let testCacheDirectory = "TestDiskCache"

    override func setUp() {
        super.setUp()
        diskCache = DiskCache(cacheDirectoryString: testCacheDirectory)
    }

    override func tearDown() {
        diskCache.clearCache()
        diskCache = nil
        super.tearDown()
    }

    func testCacheImage() {
        let bundle = Bundle.module
        let testImage = UIImage(named: "Hello_World",
                               in: bundle,
                               compatibleWith: nil)!
        let key = "testKey"

        diskCache.cacheImage(testImage, forKey: key)
        let cachedImage = diskCache.getImage(forKey: key)

        XCTAssertNotNil(cachedImage, "Cached image should not be nil")
        XCTAssertTrue(Utlis.areImagesAlmostSame(testImage, cachedImage!, tolerance: 0.01), "Cached image should be visually similar to the stored image")
    }

    func testRetrieveNonexistentImage() {
        let cachedImage = diskCache.getImage(forKey: "nonExistentKey")
        XCTAssertNil(cachedImage, "Should return nil for a non-existent key")
    }

    func testClearCache() {
        let testImage = UIImage(systemName: "star")!
        let key = "testKey"

        diskCache.cacheImage(testImage, forKey: key)
        diskCache.clearCache()

        let cachedImage = diskCache.getImage(forKey: key)
        XCTAssertNil(cachedImage, "Cache should be empty after clearing")
    }

}
