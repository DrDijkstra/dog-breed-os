//
//  OpenSpanCoreService
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-30.
//

public protocol OpenSpanCoreService {
    func getBreedList() async throws -> [BreedInfo]
    func getRandomBreedPhoto(request: BreedImageInfoRequest) async throws -> BreedImageInfoResponse
}

class OpenSpanCoreServiceImpl: OpenSpanCoreService {
    
    let breedService:BreedService
    
    init(breedService:BreedService) {
        self.breedService = breedService
    }
    
    func getBreedList() async throws -> [BreedInfo] {
        try await breedService.getBreedList()
    }
    
    func getRandomBreedPhoto(request: BreedImageInfoRequest) async throws -> BreedImageInfoResponse {
        try await breedService.getRandomBreedPhoto(request: request)
    }
}
