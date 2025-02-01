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
    @Published var breedImagesList: [BreedImage] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Dependencies
    private let openSpanCoreService: OpenSpanCoreService!
    
    weak var breedImageProvider: BreedImageProvider?
    
    // MARK: - Initializer
    init(openSpanCoreService: OpenSpanCoreService, breedImageProvider: BreedImageProvider?) {
           self.openSpanCoreService = openSpanCoreService
           self.breedImageProvider = breedImageProvider
       }

    func fetchAllBreedsAndImages() async {
        DispatchQueue.main.async {
            self.breedImagesList.removeAll()
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            let breeds = try await openSpanCoreService.getBreedList()
            DispatchQueue.main.async {
                self.breeds = breeds
                for breed in breeds {
                    self.breedImagesList.append(BreedImage(id: breed.name ?? "", name: breed.name?.capitalized ?? "", image: UIImage(named: "placeholder_image")!))
                }
                self.breedImagesList.sort(by: {$0.name < $1.name})
                self.breedImageProvider?.updateBreedImagesList(self.breedImagesList)
                self.isLoading = false
            }
            
            // Create an instance of the ImageFetcher actor
            let imageFetcher = ImageFetcher()

            try await withThrowingTaskGroup(of: BreedImage?.self) { group in
                for breed in breeds {
                    let breedName = breed.name ?? ""
                    if let cachedImage = openSpanCoreService.getImage(forKey: breedName.lowercased()) {
                        // No need to add the task if image is cached
                        await imageFetcher.append(breedImage: BreedImage(id: breedName, name: breedName.capitalized, image: cachedImage))
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

                // Collect results from the group
                for try await result in group {
                    if let breedImage = result {
                        openSpanCoreService.cacheImage(breedImage.image, forKey: breedImage.name.lowercased())
                        await imageFetcher.append(breedImage: breedImage)
                    }
                }
            }
            
            // Update the breedImagesList on the main thread
            let finalImages = await imageFetcher.getAll()
            DispatchQueue.main.async {
                self.breedImagesList = finalImages
                self.breedImagesList.sort(by: {$0.name < $1.name})
                self.breedImageProvider?.updateBreedImagesList(self.breedImagesList)
            }
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }

    @MainActor func clearCacheAndReload() async {
        breedImagesList.removeAll()
        openSpanCoreService.clearCache()
        await fetchAllBreedsAndImages()
    }
}
