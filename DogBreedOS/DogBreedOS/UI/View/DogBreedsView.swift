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
    @StateObject var viewModel: DogBreedsViewModel
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.breedImagesList.isEmpty {
                    ErrorView(message: "Failed to load images or no connection. Please try again later.")
                } else {
                    WaterfallGrid(breedImages: viewModel.breedImagesList)
                        .padding(16)
                }
            }
            .refreshable {
                await viewModel.fetchAllBreedsAndImages()
            }
            .navigationTitle("Dog Breeds")
            .toolbar {
                CacheClearButton(viewModel: viewModel)
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
