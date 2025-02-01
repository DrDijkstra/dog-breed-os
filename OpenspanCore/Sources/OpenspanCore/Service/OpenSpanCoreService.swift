//
//  OpenSpanCoreService
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-30.
//

import UIKit

public protocol OpenSpanCoreService {
    func getBreedList() async throws -> [BreedInfo]
    func getRandomBreedPhoto(request: BreedImageInfoRequest) async throws -> BreedImageInfoResponse
    func getImage(forKey key: String) async -> UIImage?
    func cacheImage(_ image: UIImage, forKey key: String) async
    func clearCache() async
}

class OpenSpanCoreServiceImpl: OpenSpanCoreService {
    
    let breedService:BreedService
    let imageCacheService:ImageCacheService
    
    init(breedService:BreedService,imageCacheService: ImageCacheService) {
        self.breedService = breedService
        self.imageCacheService = imageCacheService
    }
    
    func getBreedList() async throws -> [BreedInfo] {
        try await breedService.getBreedList()
    }
    
    func getRandomBreedPhoto(request: BreedImageInfoRequest) async throws -> BreedImageInfoResponse {
        try await breedService.getRandomBreedPhoto(request: request)
    }
    
    func getImage(forKey key: String) async -> UIImage? {
        return await imageCacheService.getImage(forKey: key)
    }
    
    func cacheImage(_ image: UIImage, forKey key: String) async {
        return await imageCacheService.cacheImage(image, forKey: key)
    }
    
    func clearCache() async {
        return await imageCacheService.clearCache()
    }
}
