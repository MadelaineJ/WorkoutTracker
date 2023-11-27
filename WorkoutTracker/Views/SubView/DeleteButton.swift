//
//  DeleteButton.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-11-10.
//

import SwiftUI

struct DeleteButton: View {
    var message: String
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false

    var body: some View {
        Button(action: {
            showingDeleteAlert = true
        }) {
            Image(systemName: "trash.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(Color(.systemIndigo))
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Do you want to delete this \(message)"),
                primaryButton: .destructive(Text("Delete")) {
                    onDelete() // Call the provided delete function
                },
                secondaryButton: .cancel()
            )
        }
    }
}

