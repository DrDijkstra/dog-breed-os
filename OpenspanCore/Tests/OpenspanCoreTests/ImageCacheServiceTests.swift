//
//  ImageCacheServiceTests.swift
//  OpenspanCore
//
//  Created by Sanjay Dey on 2025-02-01.
//


import XCTest
@testable import OpenspanCore
import UIKit

class ImageCacheServiceTests: XCTestCase {
    var imageCacheService: ImageCacheService!
    var memoryCacheService: MemoryCacheRepository!
    var diskCacheService: UserDefaultsImageCacheRepository!
    
    override func setUp() {
        super.setUp()
        memoryCacheService = MemoryCacheRepositoryImpl()
        diskCacheService = UserDefaultsImageCacheRepositoryImpl()
        imageCacheService = ImageCacheService(memoryCacheRepository: memoryCacheService, diskCacheRepository: diskCacheService)
    }
    
    override func tearDown() {
        imageCacheService = nil
        memoryCacheService = nil
        diskCacheService = nil
        super.tearDown()
    }
    
    func testCacheImage_StoresInBothMemoryAndDisk() async {
        let testImage = UIImage(systemName: "star")!
        let key = "testKey"
        
        await imageCacheService.cacheImage(testImage, forKey: key)
        
        let memoryCacheImage = await memoryCacheService.getImage(forKey: key)
        let diskCacheImage = await diskCacheService.getImage(forKey: key)
        
        XCTAssertNotNil(memoryCacheImage)
        XCTAssertNotNil(diskCacheImage)
    }
    
    func testGetImage_RetrievesFromMemoryFirst() async {
        let testImage = UIImage(systemName: "star")!
        let key = "testKey"
        
        await memoryCacheService.cacheImage(testImage, forKey: key)
        let retrievedImage = await imageCacheService.getImage(forKey: key)
        
        XCTAssertEqual(retrievedImage?.pngData(), testImage.pngData())
    }
    
    func testGetImage_RetrievesFromDiskIfNotInMemory() async {
        let bundle = Bundle.module
        let testImage = UIImage(named: "Hello_World", in: bundle, compatibleWith: nil)!
        let key = "testKey"
        
        await diskCacheService.cacheImage(testImage, forKey: key)
        
        let retrievedImageFromImageCache = await imageCacheService.getImage(forKey: key)
        let retrievedImageFromMemory = await memoryCacheService.getImage(forKey: key)
        
        XCTAssertEqual(retrievedImageFromImageCache?.pngData(), retrievedImageFromMemory?.pngData())
        XCTAssertNotNil(retrievedImageFromMemory) // Ensures it was added to memory cache
    }
    
    func testClearCache_ClearsBothMemoryAndDisk() async {
        let testImage = UIImage(systemName: "star")!
        let key = "testKey"
        
        await imageCacheService.cacheImage(testImage, forKey: key)
        await imageCacheService.clearCache()
        
        let imageFromMemory = await memoryCacheService.getImage(forKey: key)
        let imageFromDisk = await diskCacheService.getImage(forKey: key)
        
        XCTAssertNil(imageFromMemory)
        XCTAssertNil(imageFromDisk)
    }
}
