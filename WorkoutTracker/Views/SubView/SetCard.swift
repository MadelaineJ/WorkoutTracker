//
//  SetCard.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-15.
//

import SwiftUI

struct SetCard: View {
    @Binding var enteredWeight: String
    @Binding var selectedReps: Int
    
    var body: some View {
        HStack {
            // Weight TextField
            NumberField(text: $enteredWeight, placeholder: "Enter Weight")
            .keyboardType(.numberPad)
            .frame(width: 90)
            .padding(10)
            .background(Color(.systemGray5))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            Text("lbs")
            Spacer()
            Text("Reps")
            // Reps Picker
            Picker(selection: $selectedReps, label: Text("Reps")) {
                ForEach(0..<21) { i in
                    Text("\(i)").tag(i)
                }
            }
            .clipped()
            .pickerStyle(.menu)
            .labelsHidden()
            .padding(.trailing, 10)

        }
        .onTapGesture {
            self.endEditing()
        }
        .foregroundColor(Color(.label))
        .padding()
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct SetCard_Previews: PreviewProvider {
    @State static var weightPreview: String = "100"
    @State static var repsPreview: Int = 10
    
    static var previews: some View {
        SetCard(enteredWeight: $weightPreview, selectedReps: $repsPreview)
    }
}

