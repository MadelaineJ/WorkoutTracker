//
//  InlineTextEditView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-21.
//

import SwiftUI

struct InlineTextEditView: View {
    @Binding var text: String
    @State private var isEditing: Bool = false
    @FocusState private var isTextFieldFocused: Bool  // New focus state

    var body: some View {
        HStack {
            if isEditing {
                TextField("", text: $text, onCommit: {
                    isEditing = false
                })
                .autocapitalization(.none)
                .focused($isTextFieldFocused)  // Attach the focus state here
            } else {
                Text(text)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(0)
                    .onTapGesture {
                        isEditing.toggle()
                        isTextFieldFocused = true  // Set focus state to true when tapping on Text
                    }
            }
            
            if !isEditing {
                Button(action: {
                    isEditing.toggle()
                    isTextFieldFocused = true  // Set focus state to true when tapping on the pencil icon
                }) {
                    Image(systemName: "pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)  // Adjust size as needed
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

