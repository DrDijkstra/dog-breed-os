//
//  DiskImageCacheRepository.swift
//  OneSpanCore
//
//  Created by Sanjay Dey on 2025-02-02.
//

import Foundation
import UIKit

protocol DiskImageCacheRepository {
    func getImage(forKey key: String) async -> UIImage?
    func cacheImage(_ image: UIImage, forKey key: String) async
    func clearCache() async
}

class DiskImageCacheRepositoryImpl: DiskImageCacheRepository {
    private let fileManager = FileManager.default
    private let concurrentQueue = DispatchQueue(label: "com.diskcache.concurrentQueue", attributes: .concurrent)
    
    // Directory where cached images will be stored
    private var cacheDirectory: URL {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("ImageCache")
    }
    
    init() {
        // Ensure the cache directory exists
        createCacheDirectoryIfNeeded()
    }
    
    private func createCacheDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            do {
                try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create cache directory: \(error)")
            }
        }
    }
    
    private func filePath(forKey key: String) -> URL {
        let hashedKey = key.sha256()
        return cacheDirectory.appendingPathComponent(hashedKey)
    }
    
    func getImage(forKey key: String) async -> UIImage? {
        let filePath = self.filePath(forKey: key)
        
        return await withCheckedContinuation { continuation in
            concurrentQueue.async {
                if let imageData = try? Data(contentsOf: filePath),
                   let image = UIImage(data: imageData) {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    func cacheImage(_ image: UIImage, forKey key: String) async {
        guard let imageData = image.pngData() else { return }
        let filePath = self.filePath(forKey: key)
        
        await withCheckedContinuation { continuation in
            concurrentQueue.async(flags: .barrier) {
                do {
                    try imageData.write(to: filePath, options: .atomic)
                    continuation.resume()
                } catch {
                    print("Failed to cache image: \(error)")
                    continuation.resume()
                }
            }
        }
    }
    
    func clearCache() async {
        await withCheckedContinuation { continuation in
            concurrentQueue.async(flags: .barrier) {
                do {
                    let fileURLs = try self.fileManager.contentsOfDirectory(at: self.cacheDirectory, includingPropertiesForKeys: nil)
                    for fileURL in fileURLs {
                        try self.fileManager.removeItem(at: fileURL)
                    }
                    continuation.resume()
                } catch {
                    print("Failed to clear cache: \(error)")
                    continuation.resume()
                }
            }
        }
    }
}
