//
//  ImageCacheManager.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//


import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        // Create a directory for disk caching
        let directories = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = directories[0].appendingPathComponent("DogBreedImages")
        
        // Create the directory if it doesn't exist
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    // MARK: - Memory Cache
    func getImageFromMemoryCache(forKey key: String) -> UIImage? {
        return memoryCache.object(forKey: key as NSString)
    }
    
    // MARK: - Disk Cache
    func cacheImageToDisk(_ image: UIImage, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }
    
    func getImageFromDiskCache(forKey key: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL) {
            return UIImage(data: data)
        }
        return nil
    }
    
    // MARK: - Combined Cache
    func getImage(forKey key: String) -> UIImage? {
        // Check memory cache first
        if let image = getImageFromMemoryCache(forKey: key) {
            return image
        }
        
        // Check disk cache if not found in memory
        if let image = getImageFromDiskCache(forKey: key) {
            // Cache it in memory for future use
            memoryCache.setObject(image, forKey: key as NSString)
            return image
        }
        
        return nil
    }
    
    func cacheImage(_ image: UIImage, forKey key: String) {
        // Cache in memory
        memoryCache.setObject(image, forKey: key as NSString)
        
        // Cache on disk
        cacheImageToDisk(image, forKey: key)
    }
}
