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
                }
            }
            
            // Second column
            LazyVStack(spacing: 16) {
                ForEach(splitArray[1]) { breedImage in
                    BreedImageView(breedImage: breedImage, imageWidth: calculateImageWidth())
                }
            }
        }
    }
    
    // Calculate the width of each image based on screen width
   private func calculateImageWidth() -> CGFloat {
       let screenWidth = UIScreen.main.bounds.width
       return (screenWidth - 96) / 2 // Subtracting padding and spacing
   }
}

#Preview {
    let images = [BreedImage(
               id: "1",
               name: "Golden Retriever",
               image: UIImage(systemName: "photo")!
           ),
           BreedImage(
               id: "2",
               name: "Bulldog",
               image: UIImage(systemName: "photo")!
           )]
    WaterfallGrid(breedImages: images)
}
