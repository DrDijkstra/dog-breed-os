//
//  ImageFetcher.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-02-01.
//

actor ImageFetcher {
    private var tempFetchedImages: [CardData] = []
    
    func append(breedImage: CardData) {
        tempFetchedImages.append(breedImage)
    }
    
    func getAll() -> [CardData] {
        return tempFetchedImages
    }
}
