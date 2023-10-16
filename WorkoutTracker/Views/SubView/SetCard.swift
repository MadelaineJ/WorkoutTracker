//
//  SetCard.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-15.
//

import SwiftUI

struct SetCard: View {
    @State private var enteredWeight: String
    @State private var selectedReps: Int
    
    init(weight: Int64, reps: Int64) {
        _enteredWeight = State(initialValue: "\(weight)")
        _selectedReps = State(initialValue: Int(reps))
    }
    
    var body: some View {
        HStack {
            // Weight TextField
            TextField("Enter Weight (lbs)", text: $enteredWeight)
                .keyboardType(.numberPad)
                .frame(width: 100)
                .padding(10)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal, 10)

            Spacer()

            // Reps Picker
            Picker(selection: $selectedReps, label: Text("Reps")) {
                ForEach(0..<21) { i in
                    Text("\(i)").tag(i)
                }
            }
            .frame(width: 100)
            .clipped()
            .padding(.horizontal, 10)
        }
        .foregroundColor(Color(.label))
        .padding()
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 3)
        
    }
}

struct SetCard_Previews: PreviewProvider {
    static var previews: some View {
        SetCard(weight: 100, reps: 10)
    }
}
