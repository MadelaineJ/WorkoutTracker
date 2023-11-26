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
                    .foregroundColor(colour.contrastingTextColor())
                if ((creationTime) != nil) {
                    Text(creationTime, style: .date)
                        .font(.subheadline)
                        .foregroundColor(colour.contrastingTextColor())
                }
            }
            .foregroundColor(Color(.label))
            Spacer()
            Image(systemName: "chevron.right") // You can add an arrow or any other symbol to indicate a link
                .foregroundColor(colour.contrastingTextColor())
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(adjustedBackgroundColour()))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(colour.isLightColor() ? Color.black.opacity(0.1) : Color.white.opacity(0.1), lineWidth: 1)
        )

    //    .background(colour)
        .cornerRadius(8)
        
    }
    
    private func adjustedBackgroundColour() -> Color {
        return colour.isWhiteOrVeryLight() ? colour.adjustLightness(by: 0.05) : colour
    }
}

struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCard(type: "push", creationTime: Date(), colour: Color(.systemGray2))
    }
}
