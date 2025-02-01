//
//  ImageCacheManager.swift
//  OpenspanCore
//
//  Created by Sanjay Dey on 2025-01-31.
//

import UIKit

protocol CacheService {
    func getImage(forKey key: String) -> UIImage?
    func cacheImage(_ image: UIImage, forKey key: String)
    func clearCache()
}

class ImageCacheService: CacheService {
    private let memoryCacheService: MemoryCacheService
    private let diskCacheService: DiskCacheService
    
    init(memoryCacheService: MemoryCacheService, diskCacheService: DiskCacheService) {
        self.memoryCacheService = memoryCacheService
        self.diskCacheService = diskCacheService
    }
    
    func getImage(forKey key: String) -> UIImage? {
        if let image = memoryCacheService.getImage(forKey: key) {
            return image
        }
        
        // Then check disk cache
        if let image = diskCacheService.getImage(forKey: key) {
            memoryCacheService.cacheImage(image, forKey: key)
            return image
        }
        
        return nil
    }
    
    func cacheImage(_ image: UIImage, forKey key: String) {
        memoryCacheService.cacheImage(image, forKey: key)
        diskCacheService.cacheImage(image, forKey: key)
    }
    
    func clearCache() {
        memoryCacheService.clearCache()
        diskCacheService.clearCache()
    }
}
