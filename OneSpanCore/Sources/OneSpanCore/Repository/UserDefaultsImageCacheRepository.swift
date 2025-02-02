//
//  DiskCache.swift
//  OpenspanCore
//
//  Created by Sanjay Dey on 2025-01-31.
//

import Foundation
import UIKit

protocol UserDefaultsImageCacheRepository {
    func getImage(forKey key: String) async -> UIImage?
    func cacheImage(_ image: UIImage, forKey key: String) async
    func clearCache() async
}

class UserDefaultsImageCacheRepositoryImpl: UserDefaultsImageCacheRepository {
    private let userDefaults = UserDefaults.standard
    private let concurrentQueue = DispatchQueue(label: "com.diskcache.concurrentQueue", attributes: .concurrent)
    
    func getImage(forKey key: String) async -> UIImage? {
        let hashedKey = key.sha256()
        
        return await withCheckedContinuation { continuation in
            concurrentQueue.async {
                // Read from UserDefaults
                if let data = self.userDefaults.data(forKey: hashedKey) {
                    let image = UIImage(data: data)
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    func cacheImage(_ image: UIImage, forKey key: String) async {
        let hashedKey = key.sha256()
        
        await withCheckedContinuation { continuation in
            concurrentQueue.async(flags: .barrier) {
                if let data = image.pngData() {
                    self.userDefaults.set(data, forKey: hashedKey)
                }
                continuation.resume()
            }
        }
    }
    
    func clearCache() async {
        await withCheckedContinuation { continuation in
            concurrentQueue.async(flags: .barrier) {
                // Clear all data in UserDefaults
                let dictionary = self.userDefaults.dictionaryRepresentation()
                dictionary.keys.forEach { key in
                    self.userDefaults.removeObject(forKey: key)
                }
                continuation.resume()
            }
        }
    }
}
