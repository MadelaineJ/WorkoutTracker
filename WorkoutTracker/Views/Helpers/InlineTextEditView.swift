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
    
    var body: some View {
        HStack {
            if isEditing {
                TextField("", text: $text, onCommit: {
                    isEditing = false
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            } else {
                Text(text)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(0)
                    .onTapGesture {
                        isEditing.toggle()
                    }
            }
            
            if !isEditing {
                Button(action: {
                    isEditing.toggle()
                }) {
                    Image(systemName: "pencil")
                        .imageScale(.small)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
