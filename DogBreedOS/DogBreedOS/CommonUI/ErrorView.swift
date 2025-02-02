//
//  ErrorView.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//

import SwiftUI

struct ErrorView: View {
    var message: String
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(16)
    }
}

// MARK: - Preview
#Preview {
    ErrorView(message: "Failed to load images or no connection.")
}
