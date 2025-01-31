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
    
    @State private var isShimmering = false
    @State private var imageHeight: CGFloat = 0 // Initial height is 0 to trigger animation
    
    // Access the current color scheme
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            // Calculate aspect ratio
            let aspectRatio = breedImage.height / breedImage.width
            let calculatedHeight = imageWidth * aspectRatio
            
            // Check if image is a placeholder
            if breedImage.image == UIImage(named: "placeholder_image") {
                // Show shimmering effect if image is a placeholder
                ShimmeringView()
                    .frame(width: imageWidth, height: calculatedHeight)
                    .cornerRadius(8)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            imageHeight = calculatedHeight // Animate height change for placeholder
                        }
                    }
            } else {
                // Display the actual image
                Image(uiImage: breedImage.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageWidth, height: imageHeight)
                    .clipped()
                    .cornerRadius(8)
                    .opacity(imageHeight > 0 ? 1 : 0) // Fade-in effect for the image
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            imageHeight = calculatedHeight // Animate height change when image loads
                        }
                    }
            }
            
            // Display the breed name below the image
            Text(breedImage.name)
                .font(.headline)
                .lineLimit(1)
                .frame(maxWidth: imageWidth, alignment: .center)
                .padding(.top, 4)
                .foregroundColor(colorScheme == .dark ? .white : .black) // Adjust text color for dark mode
        }
        .padding() // Add padding inside the card
        .background(colorScheme == .dark ? Color(.systemGray5) : Color.white) // Use a dark gray for dark mode
        .cornerRadius(12) // Rounded corners for the card
        .shadow(radius: 5) // Add a shadow for a card-like effect
        .frame(width: imageWidth) // Constrain the card width
    }
}

#Preview {
    let image = BreedImage(
               id: "1",
               name: "Golden Retriever",
               image: UIImage(named: "placeholder_image")!
           )
    BreedImageView(breedImage: image, imageWidth: 250)
}
