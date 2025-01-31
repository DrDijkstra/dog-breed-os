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
    @Published var breedImages: [String: UIImage] = [:] // Store UIImage instead of URL
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
            // Fetch all breeds
            let breeds = try await openSpanCoreService.getBreedList()
            self.breeds = breeds
            
            // Fetch random image for each breed
            for breed in breeds {
                let breedName = breed.name ?? ""
                
                // Check cache first
                if let cachedImage = ImageCacheManager.shared.getImage(forKey: breedName) {
                    breedImages[breedName] = cachedImage
                    continue
                }
                
                // Fetch image from network if not in cache
                let request = BreedImageInfoRequest(breed: breedName)
                let response = try await openSpanCoreService.getRandomBreedPhoto(request: request)
                
                if let imageUrl = response.imageUrl, let url = URL(string: imageUrl) {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let image = UIImage(data: data) {
                        // Cache the image
                        ImageCacheManager.shared.cacheImage(image, forKey: breedName)
                        
                        // Update the published property
                        breedImages[breedName] = image
                    }
                }
            }
        } catch {
            errorMessage = "Failed to fetch data: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
