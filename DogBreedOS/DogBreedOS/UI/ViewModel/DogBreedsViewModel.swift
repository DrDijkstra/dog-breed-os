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
    @Published var breedImagesList: [BreedImage] = [] // Now holding image and its dimensions
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Dependencies
    private let openSpanCoreService: OpenSpanCoreService!
    
    // MARK: - Initializer
    init() {
        self.openSpanCoreService = OpenSpanCore.shared.openSpanCoreService
    }
    
    // MARK: - Fetch Data
    @MainActor
    func fetchAllBreedsAndImages() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let breeds = try await openSpanCoreService.getBreedList()
            self.breeds = breeds
            isLoading = false

            try await withThrowingTaskGroup(of: BreedImage?.self) { group in
                for breed in breeds {
                    let breedName = breed.name ?? ""

                    if let cachedImage = ImageCacheManager.shared.getImage(forKey: breedName) {
                        let breedImage = BreedImage(id: breedName, name: breedName, image: cachedImage)
                        await MainActor.run {
                            self.breedImagesList.append(breedImage)
                        }
                        continue
                    }

                    group.addTask {
                        do {
                            let request = BreedImageInfoRequest(breed: breedName)
                            let response = try await self.openSpanCoreService.getRandomBreedPhoto(request: request)
                            
                            if let imageUrl = response.imageUrl, let url = URL(string: imageUrl) {
                                let (data, _) = try await URLSession.shared.data(from: url)
                                if let image = UIImage(data: data) {
                                    let breedImage = BreedImage(id: breedName, name: breedName, image: image)
                                    return breedImage
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
                        ImageCacheManager.shared.cacheImage(breedImage.image, forKey: breedImage.name)
                        await MainActor.run {
                            self.breedImagesList.append(breedImage)
                        }
                    }
                }
            }
        } catch {
            errorMessage = "Failed to fetch data: \(error.localizedDescription)"
            isLoading = false
        }
    }

    @MainActor func clearCacheAndReload() async {
        breedImagesList.removeAll()
        ImageCacheManager.shared.clearCache()
        await fetchAllBreedsAndImages()
    }
}
