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
    private let memoryCacheRepository: MemoryCacheRepository
    private let diskCacheRepository: UserDefaultsImageCacheRepository
    
    init(memoryCacheRepository: MemoryCacheRepository, diskCacheRepository: UserDefaultsImageCacheRepository) {
        self.memoryCacheRepository = memoryCacheRepository
        self.diskCacheRepository = diskCacheRepository
    }
    
    func getImage(forKey key: String) async -> UIImage? {
        if let image = await memoryCacheRepository.getImage(forKey: key) {
            return image
        }
        
        // Then check disk cache
        if let image = await diskCacheRepository.getImage(forKey: key) {
            await memoryCacheRepository.cacheImage(image, forKey: key)
            return image
        }
        
        return nil
    }
    
    func cacheImage(_ image: UIImage, forKey key: String) async {
        await memoryCacheRepository.cacheImage(image, forKey: key)
        await diskCacheRepository.cacheImage(image, forKey: key)
    }
    
    func clearCache() async {
        await memoryCacheRepository.clearCache()
        await diskCacheRepository.clearCache()
    }
}
