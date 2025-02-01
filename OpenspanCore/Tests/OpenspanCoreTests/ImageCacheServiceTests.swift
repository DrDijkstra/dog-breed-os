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
        diskCacheService = DiskCache()
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
        var memoryCacheImage: UIImage?
        var diskCacheImage: UIImage?
        Task {
            await imageCacheService.cacheImage(testImage, forKey: key)
            memoryCacheImage = await memoryCacheService.getImage(forKey: key)
            diskCacheImage = await diskCacheService.getImage(forKey: key)
        }
        XCTAssertNotNil(memoryCacheImage)
        XCTAssertNotNil(diskCacheImage)
    }
    
    func testGetImage_RetrievesFromMemoryFirst() {
        let testImage = UIImage(systemName: "star")!
        let key = "testKey"
        var retrievedImage: UIImage?
        Task {
            await memoryCacheService.cacheImage(testImage, forKey: key)
            retrievedImage = await imageCacheService.getImage(forKey: key)
        }
        XCTAssertEqual(retrievedImage, testImage)
    }
    
    func testGetImage_RetrievesFromDiskIfNotInMemory() {
        let bundle = Bundle.module
        let testImage = UIImage(named: "Hello_World",
                               in: bundle,
                               compatibleWith: nil)!
        let key = "testKey"
        var retrievedImageFromImageCache: UIImage?
        var retrievedImageFromMemory: UIImage?
        Task {
            await diskCacheService.cacheImage(testImage, forKey: key)
            
            retrievedImageFromImageCache = await imageCacheService.getImage(forKey: key)
            let retrievedImageFromMemory = await memoryCacheService.getImage(forKey: key)
        }
        XCTAssertEqual(retrievedImageFromImageCache, retrievedImageFromMemory)
        XCTAssertNotNil(retrievedImageFromMemory) // Ensures it was added to memory cache
    }
    
    func testClearCache_ClearsBothMemoryAndDisk() {
        let testImage = UIImage(systemName: "star")!
        let key = "testKey"
        
        var imageFromDisk: UIImage?
        var imageFromMemory: UIImage?
        
        Task {
            await imageCacheService.cacheImage(testImage, forKey: key)
            await imageCacheService.clearCache()
            imageFromDisk = await memoryCacheService.getImage(forKey: key)
            imageFromMemory = await diskCacheService.getImage(forKey: key)
        }
        
        XCTAssertNil(imageFromDisk)
        XCTAssertNil(imageFromMemory)
    }
}
