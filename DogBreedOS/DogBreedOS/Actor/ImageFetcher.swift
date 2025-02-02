//
//  ImageFetcher.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-02-01.
//

import OneSpanCore

actor ImageFetcher {
    private var fetchedImages: [String: CardData] = [:]
    
    func append(breedImage: CardData) {
        fetchedImages[breedImage.id] = breedImage
    }
    
    func getAll(orderedBy breeds: [BreedInfo]) -> [CardData] {
        return breeds.compactMap { breed in
            guard let breedName = breed.name else { return nil }
            return fetchedImages[breedName]
        }
    }
}
