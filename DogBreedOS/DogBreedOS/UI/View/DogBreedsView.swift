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
    @State private var showDeleteConfirmation = false
    
    init(viewModel: DogBreedsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if let errorMessage = viewModel.errorMessage{
                    ErrorView(message: errorMessage)
                }
                else {
                    WaterfallGridView(viewModel: AppContainer.shared.resolve(WaterfallGridViewModel.self)!)
                        .padding(16)
                }
            }
            .refreshable {
                viewModel.breedImagesList = []
                await viewModel.fetchAllBreedsAndImages()
            }
            .navigationTitle("Dog Breeds")
            .toolbar {
                CacheClearButton{
                    Task {
                        await viewModel.clearCacheAndReload()
                    }
                }
                
                DeleteButton{
                    Task {
                        showDeleteConfirmation = true
                    }
                }
            }
            .alert("Delete All Breeds?", isPresented: $showDeleteConfirmation) {
                Button("Yes", role: .destructive) {
                    Task {
                        viewModel.deleteBreeds()
                    }
                }
                Button("No", role: .cancel) {}
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
