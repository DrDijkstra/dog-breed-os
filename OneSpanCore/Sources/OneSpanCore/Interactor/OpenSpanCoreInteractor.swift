//
//  openSpanCoreInteractor
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-30.
//

import UIKit

public protocol OneSpanCoreInteractor {
    func getBreedList() async throws -> [BreedInfo]
    func getRandomBreedPhoto(request: BreedImageInfoRequest) async throws -> BreedImageInfoResponse
    func getImage(forKey key: String) async -> UIImage?
    func cacheImage(_ image: UIImage, forKey key: String) async
    func clearCache() async
    func downloadImage(url: String) async -> UIImage?
}

class OneSpanCoreInteractorImpl: OneSpanCoreInteractor {
    
    let breedService:BreedService
    let imageCacheService:ImageCacheService
    let downloadService:DownloadService
    
    init(breedService:BreedService,imageCacheService: ImageCacheService, downloadService: DownloadService) {
        self.breedService = breedService
        self.imageCacheService = imageCacheService
        self.downloadService = downloadService
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
    
    func downloadImage(url: String) async -> UIImage?{
        await downloadService.downloadImage(url: url)
    }
}
