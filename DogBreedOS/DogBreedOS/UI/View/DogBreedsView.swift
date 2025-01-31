//
//  ContentView.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//

import SwiftUI
import OpenspanCore

struct DogBreedsView: View {
    
    // MARK: - ViewModel
    @StateObject private var viewModel = DogBreedsViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                // Define the grid columns with a flexible layout
                let columns = [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]
                
                LazyVGrid(columns: columns, spacing: 16) {
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Display each breed image dynamically
                        ForEach(viewModel.breedImagesList) { breedImage in
                            // Calculate the aspect ratio for the image
                            let aspectRatio = breedImage.height / breedImage.width
                            
                            // Display the image with dynamic height based on its aspect ratio
                            Image(uiImage: breedImage.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width / 3 - 16, height: (UIScreen.main.bounds.width / 3 - 16) * aspectRatio)
                                .clipped()
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
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

#Preview {
    DogBreedsView()
}
