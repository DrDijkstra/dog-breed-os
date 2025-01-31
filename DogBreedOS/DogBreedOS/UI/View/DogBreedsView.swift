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
    @StateObject var viewModel : DogBreedsViewModel
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                WaterfallGrid(breedImages: viewModel.breedImagesList)
                    .padding(16)
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
    let viewModel = AppContainer.shared.resolve(DogBreedsViewModel.self)
    DogBreedsView(viewModel: viewModel)
}
