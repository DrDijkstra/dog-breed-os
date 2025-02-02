//
//  DogBreedsViewModel.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//

import Foundation
import Combine
import OneSpanCore
import UIKit

class DogBreedsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var breeds: [BreedInfo] = []
    @Published var cardDataList: [CardData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Dependencies
    let interactor: OneSpanCoreInteractor
    weak var cardImageProvider: CardImageProvider?
    
    // MARK: - Initializer
    init(interactor: OneSpanCoreInteractor, cardImageProvider: CardImageProvider?) {
        self.interactor = interactor
        self.cardImageProvider = cardImageProvider
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
        await interactor.clearCache()
        await fetchAllBreedsAndImages()
    }
    
    @MainActor func deleteBreeds() {
        cardDataList.removeAll()
        cardImageProvider?.updateCardImagesList(cardDataList)
    }
    
    // MARK: - Private Methods
    private func resetState() async {
        await MainActor.run {
            cardDataList.removeAll()
            isLoading = true
            errorMessage = nil
        }
    }
    
    private func fetchBreeds() async throws -> [BreedInfo] {
        let breeds = try await interactor.getBreedList()
        return breeds.sorted { ($0.name ?? "") < ($1.name ?? "") }
    }
    
    private func updateBreeds(_ breeds: [BreedInfo]) async {
        await MainActor.run {
            self.breeds = breeds
            self.cardDataList = breeds.map {
                CardData(id: $0.name ?? "", name: $0.name?.capitalized ?? "", image: UIImage(named: "placeholder_image")!)
            }
            cardImageProvider?.updateCardImagesList(cardDataList)
        }
    }
    
    private func fetchImages(for breeds: [BreedInfo]) async throws -> [CardData] {
        let imageFetcher = ImageFetcher()
        
        try await withThrowingTaskGroup(of: CardData?.self) { group in
            for breed in breeds {
                let breedName = breed.name ?? ""
                
                if let cachedImage = await interactor.getImage(forKey: breedName.lowercased()) {
                    await imageFetcher.append(breedImage: CardData(
                        id: breedName,
                        name: breedName.capitalized,
                        image: cachedImage,
                        isImageLoaded: true
                    ))
                    continue
                }
                
                group.addTask { [weak self] in
                    guard let self = self else { return nil }
                    return await self.fetchBreedImage(for: breedName)
                }
            }
            
            for try await result in group {
                if let breedImage = result {
                    await interactor.cacheImage(breedImage.image, forKey: breedImage.name.lowercased())
                    await imageFetcher.append(breedImage: breedImage)
                }
            }
        }
        
        return await imageFetcher.getAll(orderedBy: breeds)
    }
    
    private func fetchBreedImage(for breedName: String) async -> CardData? {
        do {
            let request = BreedImageInfoRequest(breed: breedName)
            let response = try await interactor.getRandomBreedPhoto(request: request)
            
            guard let imageUrl = response.imageUrl, let url = URL(string: imageUrl) else { return nil }
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else { return nil }
            return CardData(id: breedName, name: breedName.capitalized, image: image, isImageLoaded: true)
        } catch {
            print("Error fetching image for \(breedName): \(error)")
            return nil
        }
    }
    
    private func updateBreedImages(_ breedImages: [CardData]) async {
        await MainActor.run {
            self.cardDataList = breedImages
            self.cardImageProvider?.updateCardImagesList(cardDataList)
            self.isLoading = false
        }
    }
    
    private func handleError(_ error: Error) async {
        await MainActor.run {
            self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
}
