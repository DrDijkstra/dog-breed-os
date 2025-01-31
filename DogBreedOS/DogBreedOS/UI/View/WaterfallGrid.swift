//
//  WaterfallGrid.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//

import SwiftUI
import OpenspanCore

struct WaterfallGrid: View {
    let breedImages: [BreedImage]
    
    // Split the breed images into two columns
    private var splitArray: [[BreedImage]] {
        var result: [[BreedImage]] = [[], []]
        
        for (index, breedImage) in breedImages.enumerated() {
            if index % 2 == 0 {
                result[0].append(breedImage)
            } else {
                result[1].append(breedImage)
            }
        }
        
        return result
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // First column
            LazyVStack(spacing: 16) {
                ForEach(splitArray[0]) { breedImage in
                    BreedImageView(breedImage: breedImage, imageWidth: calculateImageWidth())
                        .transition(.asymmetric(insertion: .scale, removal: .opacity)) // Added transition for smooth appearance
                }
            }
            
            // Second column
            LazyVStack(spacing: 16) {
                ForEach(splitArray[1]) { breedImage in
                    BreedImageView(breedImage: breedImage, imageWidth: calculateImageWidth())
                        .transition(.asymmetric(insertion: .scale, removal: .opacity)) // Added transition for smooth appearance
                }
            }
        }
        .padding(.horizontal, 4)
    }
    
    // Calculate the width of each image based on screen width
    private func calculateImageWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth - 128) / 2 // Subtracting padding and spacing for two columns
    }
}

#Preview {
    let images = [
        BreedImage(id: "1", name: "Golden Retriever", image: UIImage(named: "placeholder_image")!),
        BreedImage(id: "2", name: "Bulldog", image: UIImage(named: "placeholder_image")!)
    ]
    WaterfallGrid(breedImages: images)
}
