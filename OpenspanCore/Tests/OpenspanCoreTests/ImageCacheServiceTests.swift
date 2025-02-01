//
//  ImageCacheServiceTests.swift
//  OpenspanCore
//
//  Created by Sanjay Dey on 2025-02-01.
//


import XCTest
@testable import OpenspanCore

class ImageCacheServiceTests: XCTestCase {
    var imageCacheService: ImageCacheService!
    var memoryCacheService: MemoryCacheService!
    var diskCacheService: DiskCacheService!
    
    override func setUp() {
        super.setUp()
        memoryCacheService = MemoryCache()
        diskCacheService = DiskCache(cacheDirectoryString: "Test")
        imageCacheService = ImageCacheService(memoryCacheService: memoryCacheService, diskCacheService: diskCacheService)
    }
    
    override func tearDown() {
        imageCacheService = nil
        memoryCacheService = nil
        diskCacheService = nil
        super.tearDown()
    }
    
    func testCacheImage_StoresInBothMemoryAndDisk() {
        let testImage = UIImage(systemName: "star")!
        let key = "testKey"
        
        imageCacheService.cacheImage(testImage, forKey: key)
        
        XCTAssertNotNil(memoryCacheService.getImage(forKey: key))
        XCTAssertNotNil(diskCacheService.getImage(forKey: key))
    }
    
    func testGetImage_RetrievesFromMemoryFirst() {
        let testImage = UIImage(systemName: "star")!
        let key = "testKey"
        
        memoryCacheService.cacheImage(testImage, forKey: key)
        
        let retrievedImage = imageCacheService.getImage(forKey: key)
        XCTAssertEqual(retrievedImage, testImage)
    }
    
    func testGetImage_RetrievesFromDiskIfNotInMemory() {
        let bundle = Bundle.module
        let testImage = UIImage(named: "Hello_World",
                               in: bundle,
                               compatibleWith: nil)!
        let key = "testKey"
        
        diskCacheService.cacheImage(testImage, forKey: key)
        
        let retrievedImage = imageCacheService.getImage(forKey: key)
        XCTAssertTrue(Utlis.areImagesAlmostSame(testImage, retrievedImage!, tolerance: 0.02), "Cached image should be visually similar to the stored image")
        XCTAssertNotNil(memoryCacheService.getImage(forKey: key)) // Ensures it was added to memory cache
    }
    
    func testClearCache_ClearsBothMemoryAndDisk() {
        let testImage = UIImage(systemName: "star")!
        let key = "testKey"
        
        imageCacheService.cacheImage(testImage, forKey: key)
        imageCacheService.clearCache()
        
        XCTAssertNil(memoryCacheService.getImage(forKey: key))
        XCTAssertNil(diskCacheService.getImage(forKey: key))
    }
}
