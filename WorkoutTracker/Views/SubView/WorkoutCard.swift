//
//  WorkoutCard.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-14.
//

import SwiftUI
import CoreData

struct WorkoutCard: View {
    var type: String
    var creationTime: Date!
    var colour: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(type)
                    .font(.headline)
                if ((creationTime) != nil) {
                    Text(creationTime, style: .date)
                        .font(.subheadline)
                }

            }
            .foregroundColor(Color(.label))
            Spacer()
            Image(systemName: "chevron.right") // You can add an arrow or any other symbol to indicate a link
                .foregroundColor(Color(.label))
        }
        .padding()
        .background(colour)
        .cornerRadius(8)
        .shadow(radius: 2)
        .onAppear() {
            print(colour)
        }
        
    }
}

struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCard(type: "push", creationTime: Date(), colour: Color(.systemGray2))
    }
}
