//
//  MemoryCacheService.swift
//  OpenspanCore
//
//  Created by Sanjay Dey on 2025-01-31.
//


import Foundation
import UIKit

protocol MemoryCacheRepository {
    func getImage(forKey key: String) async -> UIImage?
    func cacheImage(_ image: UIImage, forKey key: String) async
    func clearCache() async
}

class MemoryCacheRepositoryImpl: MemoryCacheRepository {
    
    private let memoryCache = NSCache<NSString, UIImage>()
    
    private let cacheQueue = DispatchQueue(label: "com.example.cacheQueue")

    func getImage(forKey key: String) async -> UIImage? {
        await withCheckedContinuation { continuation in
            cacheQueue.async {
                let image = self.memoryCache.object(forKey: key as NSString)
                continuation.resume(returning: image)
            }
        }
    }

    func cacheImage(_ image: UIImage, forKey key: String) async {
        await withCheckedContinuation { continuation in
            cacheQueue.async {
                self.memoryCache.setObject(image, forKey: key as NSString)
                continuation.resume()
            }
        }
    }

    func clearCache() async {
        await withCheckedContinuation { continuation in
            cacheQueue.async {
                self.memoryCache.removeAllObjects()
                continuation.resume()
            }
        }
    }
}

