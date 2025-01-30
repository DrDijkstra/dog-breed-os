//
//  BreedService.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//


protocol BreedService {
    func getBreedList() async throws -> [BreedInfo]
    func getRandomBreedPhoto(request: BreedImageInfoRequest) async throws -> BreedImageInfoResponse
}

class BreedServiceImpl: BreedService {
    private let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func getBreedList() async throws -> [BreedInfo] {
        let breedApiResponse = try await apiService.getBreedList()
        return breedApiResponse.message.map { BreedInfo(name: $0.key, subbreeeds: $0.value) }
    }
    
    func getRandomBreedPhoto(request: BreedImageInfoRequest) async throws -> BreedImageInfoResponse {
        guard let breedName = request.breed else {
            throw ApiError.invalidRequest("Breed name is required")
        }
        
        let apiResponse = try await apiService.getRandomBreedPhoto(request: ApiRandomBreedImageRequest(breed: breedName))
        return BreedImageInfoResponse(imageUrl: apiResponse.message)
    }
}
