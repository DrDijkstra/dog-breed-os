//
//  ImageCacheManager.swift
//  OpenspanCore
//
//  Created by Sanjay Dey on 2025-01-31.
//

import UIKit

protocol CacheService {
    func getImage(forKey key: String) async -> UIImage?
    func cacheImage(_ image: UIImage, forKey key: String) async
    func clearCache() async
}

class ImageCacheService: CacheService {
    private let memoryCacheService: MemoryCacheService
    private let diskCacheService: DiskCacheService
    
    init(memoryCacheService: MemoryCacheService, diskCacheService: DiskCacheService) {
        self.memoryCacheService = memoryCacheService
        self.diskCacheService = diskCacheService
    }
    
    func getImage(forKey key: String) async -> UIImage? {
        if let image = await memoryCacheService.getImage(forKey: key) {
            return image
        }
        
        // Then check disk cache
        if let image = await diskCacheService.getImage(forKey: key) {
            await memoryCacheService.cacheImage(image, forKey: key)
            return image
        }
        
        return nil
    }
    
    func cacheImage(_ image: UIImage, forKey key: String) async {
        await memoryCacheService.cacheImage(image, forKey: key)
        await diskCacheService.cacheImage(image, forKey: key)
    }
    
    func clearCache() async {
        await memoryCacheService.clearCache()
        await diskCacheService.clearCache()
    }
}
