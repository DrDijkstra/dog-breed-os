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
            List {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    ForEach(viewModel.breedImagesList) { breedImage in
                        if let breed = breed(for: breedImage.name) {
                            BreedRow(breed: breed, image: breedImage.image)
                                .transition(.slide)
                        }
                    }
                }
            }
            .animation(.default, value: viewModel.breedImagesList)
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
    
    // MARK: - Helper Function
    private func breed(for name: String) -> BreedInfo? {
        return viewModel.breeds.first { $0.name == name }
    }
}

#Preview {
    DogBreedsView()
}
