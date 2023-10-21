//
//  NumberField.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-20.
//

import SwiftUI

struct NumberField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    
    func makeUIView(context: Context) -> CustomUITextField {
        let textField = CustomUITextField(placeholder: placeholder)
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: CustomUITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: NumberField

        init(_ parent: NumberField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}
