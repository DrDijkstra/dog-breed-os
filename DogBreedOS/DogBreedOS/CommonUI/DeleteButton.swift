//
//  DeleteButton.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-02-01.
//

import SwiftUI

struct DeleteButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "trash")
                .font(.headline)
        }
    }
}

// MARK: - Preview
#Preview {
    DeleteButton(action: {})
}
