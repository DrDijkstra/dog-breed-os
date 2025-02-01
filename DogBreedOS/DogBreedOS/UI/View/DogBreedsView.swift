//
//  BreedRow.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//

import SwiftUI
import OpenspanCore

struct DogBreedsView: View {
    
    @StateObject private var viewModel: DogBreedsViewModel
    
    init(viewModel: DogBreedsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.breedImagesList.isEmpty {
                    ErrorView(message: "Failed to load images or no connection. Please try again later.")
                } else {
                    WaterfallGridView(viewModel: AppContainer.shared.resolve(WaterfallGridViewModel.self)!)
                        .padding(16)
                }
            }
            .refreshable {
                await viewModel.fetchAllBreedsAndImages()
            }
            .navigationTitle("Dog Breeds")
            .toolbar {
                CacheClearButton{
                    Task {
                        await viewModel.clearCacheAndReload()
                    }
                }
            }
            .task {
                await viewModel.fetchAllBreedsAndImages()
            }
        }
    }
}

#Preview {
    let viewModel = AppContainer.shared.resolve(DogBreedsViewModel.self)!
    return DogBreedsView(viewModel: viewModel)
}
