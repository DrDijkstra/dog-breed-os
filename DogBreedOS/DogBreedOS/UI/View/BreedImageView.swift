//
//  BreedImageView.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//

import SwiftUI
import OpenspanCore

struct BreedImageView: View {
    let breedImage: BreedImage
    let imageWidth: CGFloat
    
    var body: some View {
        VStack {
            // Calculate aspect ratio
            let aspectRatio = breedImage.height / breedImage.width
            let imageHeight = imageWidth * aspectRatio
            
            // Display the image
            Image(uiImage: breedImage.image)
                .resizable()
                .scaledToFill()
                .frame(width: imageWidth, height: imageHeight)
                .clipped()
                .cornerRadius(8)
            
            // Display the breed name below the image
            Text(breedImage.name)
                .font(.headline)
                .lineLimit(1)
                .frame(maxWidth: imageWidth, alignment: .center)
                .padding(.top, 4)
        }
        .padding() // Add padding inside the card
        .background(Color.white) // Set card background color
        .cornerRadius(12) // Rounded corners for the card
        .shadow(radius: 5) // Add a shadow for a card-like effect
        .frame(width: imageWidth) // Constrain the card width
    }
}

#Preview {
    let image = BreedImage(
               id: "1",
               name: "Golden Retriever",
               image: UIImage(systemName: "photo")!
           )
    BreedImageView(breedImage: image, imageWidth: 250)
}
