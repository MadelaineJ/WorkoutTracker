//
//  SetCard.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-15.
//

import SwiftUI

struct SetCard: View {
    var weight: Int64
    var reps: Int64
    
    var body: some View {
        HStack {
                Text(String(weight) + " lbs")
                .font(.title2)
                    .padding(.horizontal, 25)
                Spacer()
                Text(String(reps) + " reps")
                    .font(.title2)
                    .padding(.horizontal, 25)
                


            
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
