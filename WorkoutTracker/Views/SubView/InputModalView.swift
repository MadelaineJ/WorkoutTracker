//
//  InputModalView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-15.
//

import SwiftUI

struct InputModalView: View {
    @Binding var inputText: String
    var onSubmit: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField("Enter text here", text: $inputText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
            
            Button(action: {
                onSubmit()
                self.inputText = ""
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Submit")
            }
            .padding()
        }
    }
}


struct InputModalView_Previews: PreviewProvider {
    @State static private var previewText: String = "Sample Text"
    
    static var previews: some View {
        InputModalView(inputText: $previewText, onSubmit: {
            print("Submit action from preview")
        })
    }
}

