import SwiftUI
import OpenspanCore

import SwiftUI
import OpenspanCore

struct DogBreedsView: View {
    
    // MARK: - ViewModel
    @StateObject private var viewModel = DogBreedsViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                // Use the waterfall grid layout
                WaterfallGrid(breedImages: viewModel.breedImagesList)
                    .padding(16) // Add padding around the grid
            }
            .navigationTitle("Dog Breeds")
            .toolbar {
                Button(action: {
                    Task {
                        await viewModel.clearCacheAndReload()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.headline)
                }
            }
            .task {
                await viewModel.fetchAllBreedsAndImages()
            }
        }
    }
}

// MARK: - Waterfall Grid Component
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
        return (screenWidth - 48) / 2 // Subtracting padding and spacing
    }
}

// MARK: - BreedImageView
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
    }
}

#Preview {
    DogBreedsView()
}
