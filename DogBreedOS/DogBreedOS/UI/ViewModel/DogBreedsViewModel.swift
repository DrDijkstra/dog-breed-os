//
//  DogBreedsViewModel.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//

import Foundation
import Combine
import OpenspanCore
import UIKit

class DogBreedsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var breeds: [BreedInfo] = []
    @Published var cardDataList: [CardData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Dependencies
    private let openSpanCoreService: OpenSpanCoreService!
    weak var breedImageProvider: CardImageProvider?
    
    // MARK: - Initializer
    init(openSpanCoreService: OpenSpanCoreService, cardImageProvider: CardImageProvider?) {
        self.openSpanCoreService = openSpanCoreService
        self.breedImageProvider = cardImageProvider
    }
    
    // MARK: - Public Methods
    func fetchAllBreedsAndImages() async {
        await resetState()
        
        do {
            let breeds = try await fetchBreeds()
            await updateBreeds(breeds)
            
            let breedImages = try await fetchImages(for: breeds)
            await updateBreedImages(breedImages)
            
        } catch {
            await handleError(error)
        }
    }
    
    @MainActor func clearCacheAndReload() async {
        cardDataList.removeAll()
        await openSpanCoreService.clearCache()
        await fetchAllBreedsAndImages()
    }
    
    @MainActor func deleteBreeds() {
        self.cardDataList.removeAll()
        self.breedImageProvider?.updateCardImagesList(self.cardDataList)
    }
    
    // MARK: - Private Methods
    
    private func resetState() async {
        DispatchQueue.main.async {
            self.cardDataList.removeAll()
            self.isLoading = true
            self.errorMessage = nil
        }
    }
    
    private func fetchBreeds() async throws -> [BreedInfo] {
        return try await openSpanCoreService.getBreedList()
    }
    
    private func updateBreeds(_ breeds: [BreedInfo]) async {
        DispatchQueue.main.async {
            self.breeds = breeds
            self.cardDataList = breeds.map {
                CardData(id: $0.name ?? "", name: $0.name?.capitalized ?? "", image: UIImage(named: "placeholder_image")!)
            }
            self.cardDataList.sort(by: { $0.name < $1.name })
            self.breedImageProvider?.updateCardImagesList(self.cardDataList)
        }
    }
    
    private func fetchImages(for breeds: [BreedInfo]) async throws -> [CardData] {
        let imageFetcher = ImageFetcher()
        
        try await withThrowingTaskGroup(of: CardData?.self) { group in
            for breed in breeds {
                let breedName = breed.name ?? ""
                if let cachedImage = await openSpanCoreService.getImage(forKey: breedName.lowercased()) {
                    let cardData = CardData(id: breedName, name: breedName.capitalized, image: cachedImage, isImageLoaded: true)
                    await imageFetcher.append(breedImage: cardData)
                    continue
                }
                
                group.addTask {
                    do {
                        let request = BreedImageInfoRequest(breed: breedName)
                        let response = try await self.openSpanCoreService.getRandomBreedPhoto(request: request)
                        
                        if let imageUrl = response.imageUrl, let url = URL(string: imageUrl) {
                            let (data, _) = try await URLSession.shared.data(from: url)
                            if let image = UIImage(data: data) {
                                return CardData(id: breedName, name: breedName.capitalized, image: image, isImageLoaded: true)
                            }
                        }
                    } catch {
                        print("Error fetching image for \(breedName): \(error)")
                    }
                    return nil
                }
            }
            
            for try await result in group {
                if let breedImage = result {
                    await openSpanCoreService.cacheImage(breedImage.image, forKey: breedImage.name.lowercased())
                    await imageFetcher.append(breedImage: breedImage)
                }
            }
        }
        
        return await imageFetcher.getAll()
    }
    
    private func updateBreedImages(_ breedImages: [CardData]) async {
        let sortedData = breedImages.sorted(by: { $0.name < $1.name })
        DispatchQueue.main.async {
            self.cardDataList = sortedData
            self.breedImageProvider?.updateCardImagesList(self.cardDataList)
            self.isLoading = false
        }
    }
    
    private func handleError(_ error: Error) async {
        DispatchQueue.main.async {
            self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
}
