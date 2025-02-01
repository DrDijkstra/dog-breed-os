//
//  DiskCache.swift
//  OpenspanCore
//
//  Created by Sanjay Dey on 2025-01-31.
//

import Foundation
import UIKit

protocol DiskCacheService {
    func getImage(forKey key: String) -> UIImage?
    func cacheImage(_ image: UIImage, forKey key: String)
    func clearCache()
}

class DiskCache: DiskCacheService {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init(cacheDirectoryString: String) {
        let directories = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = directories[0].appendingPathComponent(cacheDirectoryString)
        createCacheDirectoryIfNeeded()
    }
    
    private func createCacheDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func getImage(forKey key: String) -> UIImage? {
        let hashedKey = key.sha256()
        let fileURL = cacheDirectory.appendingPathComponent(hashedKey)
        if let data = try? Data(contentsOf: fileURL) {
            return UIImage(data: data)
        }
        return nil
    }
    
    func cacheImage(_ image: UIImage, forKey key: String) {
        let hashedKey = key.sha256()
        let fileURL = cacheDirectory.appendingPathComponent(hashedKey)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }
    
    func clearCache() {
        if fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.removeItem(at: cacheDirectory)
        }
    }
}
