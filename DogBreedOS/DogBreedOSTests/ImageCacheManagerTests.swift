//
//  ImageCacheManagerTests.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//


import XCTest
import OpenspanCore
import CoreImage
@testable import DogBreedOS

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
        let testImage = UIImage(named: "placeholder_image")!
        let key = "testKey"
        
        // Cache image and verify
        imageCacheManager.cacheImage(testImage, forKey: key)
        let cachedImage = imageCacheManager.getImageFromMemoryCache(forKey: key)
        
        XCTAssertNotNil(cachedImage, "Image should be cached in memory")
        XCTAssertEqual(cachedImage!.pngData(), testImage.pngData(), "Cached image should match the original image")
    }
    
    func testDiskCache() {
        let testImage = UIImage(named: "placeholder_image")!
        let key = "testKey"
        
        // Cache image to disk and verify
        imageCacheManager.cacheImageToDisk(testImage, forKey: key)
        let cachedImage = imageCacheManager.getImageFromDiskCache(forKey: key)
        
        XCTAssertNotNil(cachedImage, "Image should be cached on disk")
        
        // Compare image data
        if let testImageData = testImage.pngData(), let cachedImageData = cachedImage?.pngData() {
            let result = areImagesAlmostSame(testImage, UIImage(data: cachedImageData)!, tolerance: 0.01)
            XCTAssertTrue(result, "Cached image data should match the original image data")
        } else {
            XCTFail("Failed to convert images to PNG data")
        }
    }
    
    func testCombinedCache() {
        let testImage = UIImage(named: "placeholder_image")!
        let key = "testKey"
        
        // Cache image using combined method and verify
        imageCacheManager.cacheImage(testImage, forKey: key)
        let cachedImage = imageCacheManager.getImage(forKey: key)
        
        XCTAssertNotNil(cachedImage, "Image should be cached in memory and on disk")
        XCTAssertEqual(cachedImage!.pngData(), testImage.pngData(), "Cached image should match the original image")
    }
    
    func testClearCache() {
        let testImage = UIImage(named: "placeholder_image")!
        let key = "testKey"
        
        // Cache image and clear cache
        imageCacheManager.cacheImage(testImage, forKey: key)
        imageCacheManager.clearCache()
        
        // Verify cache is cleared
        let memoryCachedImage = imageCacheManager.getImageFromMemoryCache(forKey: key)
        let diskCachedImage = imageCacheManager.getImageFromDiskCache(forKey: key)
        
        XCTAssertNil(memoryCachedImage, "Memory cache should be cleared")
        XCTAssertNil(diskCachedImage, "Disk cache should be cleared")
    }

    private func areImagesAlmostSame(_ image1: UIImage, _ image2: UIImage, tolerance: CGFloat = 0.01) -> Bool {
        guard let cgImage1 = image1.cgImage, let cgImage2 = image2.cgImage else {
            return false
        }
        
        // Ensure both images have the same dimensions
        guard cgImage1.width == cgImage2.width && cgImage1.height == cgImage2.height else {
            return false
        }
        
        // Create context for pixel data extraction
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let context1 = CGContext(data: nil, width: cgImage1.width, height: cgImage1.height, bitsPerComponent: 8, bytesPerRow: cgImage1.width * 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue),
              let context2 = CGContext(data: nil, width: cgImage2.width, height: cgImage2.height, bitsPerComponent: 8, bytesPerRow: cgImage2.width * 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return false
        }
        
        context1.draw(cgImage1, in: CGRect(x: 0, y: 0, width: cgImage1.width, height: cgImage1.height))
        context2.draw(cgImage2, in: CGRect(x: 0, y: 0, width: cgImage2.width, height: cgImage2.height))
        
        guard let pixelData1 = context1.data, let pixelData2 = context2.data else {
            return false
        }
        
        let buffer1 = pixelData1.bindMemory(to: UInt8.self, capacity: cgImage1.width * cgImage1.height * 4)
        let buffer2 = pixelData2.bindMemory(to: UInt8.self, capacity: cgImage2.width * cgImage2.height * 4)
        
        var differentPixels = 0
        
        // Compare pixel data with tolerance
        for i in 0 ..< cgImage1.width * cgImage1.height * 4 {
            let diff = abs(Int(buffer1[i]) - Int(buffer2[i]))
            if diff > Int(tolerance * 255) {
                differentPixels += 1
            }
        }
        
        // Allow a small percentage of pixels to differ
        let totalPixels = cgImage1.width * cgImage1.height
        let maxDifferentPixels = Int(0.01 * Double(totalPixels)) // 1% tolerance
        
        return differentPixels <= maxDifferentPixels
    }
}
