//
//  WorkoutCard.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-14.
//

import SwiftUI

struct WorkoutCard: View {
    var type: String
    var creationTime: Date
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(type)
                    .font(.headline)
                Text(creationTime, style: .date)
                    .font(.subheadline)

            }
            .foregroundColor(Color(.label))
            Spacer()
            Image(systemName: "chevron.right") // You can add an arrow or any other symbol to indicate a link
                .foregroundColor(Color(.label))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 3)
        
    }
}

struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCard(type: "push", creationTime: Date())
    }
}
