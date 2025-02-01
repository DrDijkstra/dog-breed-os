//
//  MemoryCacheService.swift
//  OpenspanCore
//
//  Created by Sanjay Dey on 2025-01-31.
//


import Foundation
import UIKit

protocol MemoryCacheService {
    func getImage(forKey key: String) -> UIImage?
    func cacheImage(_ image: UIImage, forKey key: String)
    func clearCache()
}

class MemoryCache: MemoryCacheService {
    private let memoryCache = NSCache<NSString, UIImage>()
    
    func getImage(forKey key: String) -> UIImage? {
        return memoryCache.object(forKey: key as NSString)
    }
    
    func cacheImage(_ image: UIImage, forKey key: String) {
        memoryCache.setObject(image, forKey: key as NSString)
    }
    
    func clearCache() {
        memoryCache.removeAllObjects()
    }
}
