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
            for breed in breeds {
                breedImagesList.append(BreedImage(id: breed.name ?? "", name: breed.name?.capitalized ?? "", image: UIImage(named: "placeholder_image")!))
            }
            isLoading = false
            
            var fetchedImages: [BreedImage] = []
            
            try await withThrowingTaskGroup(of: BreedImage?.self) { group in
                for breed in breeds {
                    let breedName = breed.name ?? ""
                    
                    if let cachedImage = ImageCacheManager.shared.getImage(forKey: breedName) {
                        fetchedImages.append(BreedImage(id: breedName, name: breedName.capitalized, image: cachedImage))
                        continue
                    }
                    
                    group.addTask {
                        do {
                            let request = BreedImageInfoRequest(breed: breedName)
                            let response = try await self.openSpanCoreService.getRandomBreedPhoto(request: request)
                            
                            if let imageUrl = response.imageUrl, let url = URL(string: imageUrl) {
                                let (data, _) = try await URLSession.shared.data(from: url)
                                if let image = UIImage(data: data) {
                                    return BreedImage(id: breedName, name: breedName.capitalized, image: image)
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
                        fetchedImages.append(breedImage)
                    }
                }
            }
            
            // Step 3: Update with the real images
            await MainActor.run {
                self.breedImagesList = fetchedImages
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
