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
                if let errorMessage = viewModel.errorMessage {
                    ErrorView(message: errorMessage)
                        .accessibilityIdentifier("errorView") // Add identifier for error view
                }
                else {
                    WaterfallGridView(viewModel: AppContainer.shared.resolve(WaterfallGridViewModel.self)!)
                        .padding(16)
                        .accessibilityIdentifier("waterfallGridView") // Add identifier for grid view
                }
            }
            .refreshable {
                viewModel.cardDataList = []
                await viewModel.fetchAllBreedsAndImages()
            }
            .navigationTitle("Dog Breeds")
            .toolbar {
                CacheClearButton {
                    Task {
                        await viewModel.clearCacheAndReload()
                    }
                }
                .accessibilityIdentifier("cacheClearButton") // Add identifier for cache clear button
                
                DeleteButton {
                    Task {
                        showDeleteConfirmation = true
                    }
                }
                .accessibilityIdentifier("deleteButton") // Add identifier for delete button
            }
            .alert("Delete All Breeds?", isPresented: $showDeleteConfirmation) {
                Button("Yes", role: .destructive) {
                    Task {
                        viewModel.deleteBreeds()
                    }
                }
                .accessibilityIdentifier("deleteConfirmationYesButton") // Add identifier for "Yes" button
                
                Button("No", role: .cancel) {}
                .accessibilityIdentifier("deleteConfirmationNoButton") // Add identifier for "No" button
            }
            .task {
                await viewModel.fetchAllBreedsAndImages()
            }
            .accessibilityIdentifier("dogBreedsScrollView") // Add identifier for the ScrollView
        }
    }
}

#Preview {
    let viewModel = AppContainer.shared.resolve(DogBreedsViewModel.self)!
    return DogBreedsView(viewModel: viewModel)
}
