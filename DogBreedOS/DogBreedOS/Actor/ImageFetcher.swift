//
//  ImageFetcher.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-02-01.
//


// MARK: - Fetch Data
actor ImageFetcher {
    private var tempFetchedImages: [BreedImage] = []
    
    func append(breedImage: BreedImage) {
        tempFetchedImages.append(breedImage)
    }
    
    func getAll() -> [BreedImage] {
        return tempFetchedImages
    }
}
