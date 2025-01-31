//
//  BreedRow.swift
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

#Preview {
    DogBreedsView()
}
