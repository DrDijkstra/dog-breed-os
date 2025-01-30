//
//  ApiRandomBreedImageRequest.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//

final class ApiRandomBreedImageRequest: Codable, Sendable {
    let breed: String
    
    init(breed: String) {
        self.breed = breed
    }
}
