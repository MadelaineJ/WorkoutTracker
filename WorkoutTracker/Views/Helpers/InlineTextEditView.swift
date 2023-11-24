//
//  InlineTextEditView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-21.
//

import SwiftUI

struct InlineTextEditView: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    var isTextFieldFocused: FocusState<Bool>.Binding

    var onCommit: () -> Void = {}

    var body: some View {
        HStack {
            if isEditing {
                TextField("", text: $text, onCommit: {
                    isEditing = false
                    onCommit()
                })
                .autocapitalization(.none)
                .focused(isTextFieldFocused)
            } else {
                Text(text)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(0)
                    .onTapGesture {
                        isEditing = true
                        isTextFieldFocused.wrappedValue = true
                    }
            }
            
            if !isEditing {
                Button(action: {
                    isEditing.toggle()
                    isTextFieldFocused.wrappedValue = true  // Set focus state to true when tapping on the pencil icon
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

