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
            FirstResponderTextField(text: $inputText, placeholder: "Enter Workout Type", onCommit: {
                self.onSubmit()
                self.presentationMode.wrappedValue.dismiss() // Dismiss the modal
            })
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
            
            Button(action: {
                onSubmit()
                
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Submit")
            }
            .padding()
        }
        .onAppear() {
            self.inputText = ""
        }
    }
}


struct InputModalView_Previews: PreviewProvider {
    @State static private var previewText: String = ""
    
    static var previews: some View {
        InputModalView(inputText: $previewText, onSubmit: {
            print("Submit action from preview")
        })
    }
}

