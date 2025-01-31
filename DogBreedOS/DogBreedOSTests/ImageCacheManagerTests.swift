//
//  ImageCacheManagerTests.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//


import XCTest
import OpenspanCore
@testable import DogBreedOS // Replace with your actual module name

class ImageCacheManagerTests: XCTestCase {
    
    var imageCacheManager: ImageCacheManager!
    
    override func setUp() {
        super.setUp()
        imageCacheManager = ImageCacheManager.shared
    }
    
    override func tearDown() {
        imageCacheManager.clearCache()
        imageCacheManager = nil
        super.tearDown()
    }
    
    func testMemoryCache() {
        // Load the placeholder image from the asset catalog
        let testImage = UIImage(named: "placeholder_image")!
        let key = "testKey"
        
        // Cache the image in memory
        imageCacheManager.cacheImage(testImage, forKey: key)
        
        // Retrieve the image from memory cache
        let cachedImage = imageCacheManager.getImageFromMemoryCache(forKey: key)
        
        XCTAssertNotNil(cachedImage, "Image should be cached in memory")
        XCTAssertEqual(cachedImage!.pngData(), testImage.pngData(), "Cached image should match the original image")
    }
    
    func testDiskCache() {
        // Load the placeholder image from the asset catalog
        let testImage = UIImage(named: "placeholder_image")!
        let key = "testKey"
        
        // Cache the image on disk
        imageCacheManager.cacheImageToDisk(testImage, forKey: key)
        
        // Retrieve the image from disk cache
        let cachedImage = imageCacheManager.getImageFromDiskCache(forKey: key)
        
        XCTAssertNotNil(cachedImage, "Image should be cached on disk")
        XCTAssertEqual(cachedImage!.pngData(), testImage.pngData(), "Cached image should match the original image")
    }
    
    func testCombinedCache() {
        // Load the placeholder image from the asset catalog
        let testImage = UIImage(named: "placeholder_image")!
        let key = "testKey"
        
        // Cache the image using the combined method
        imageCacheManager.cacheImage(testImage, forKey: key)
        
        // Retrieve the image using the combined method
        let cachedImage = imageCacheManager.getImage(forKey: key)
        
        XCTAssertNotNil(cachedImage, "Image should be cached in memory and on disk")
        XCTAssertEqual(cachedImage!.pngData(), testImage.pngData(), "Cached image should match the original image")
    }
    
    func testClearCache() {
        // Load the placeholder image from the asset catalog
        let testImage = UIImage(named: "placeholder_image")!
        let key = "testKey"
        
        // Cache the image
        imageCacheManager.cacheImage(testImage, forKey: key)
        
        // Clear the cache
        imageCacheManager.clearCache()
        
        // Attempt to retrieve the image from memory and disk
        let memoryCachedImage = imageCacheManager.getImageFromMemoryCache(forKey: key)
        let diskCachedImage = imageCacheManager.getImageFromDiskCache(forKey: key)
        
        XCTAssertNil(memoryCachedImage, "Memory cache should be cleared")
        XCTAssertNil(diskCachedImage, "Disk cache should be cleared")
    }
}
