//
//  WorkoutCard.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-14.
//

import SwiftUI
import CoreData

struct WorkoutCard: View {
    @Environment(\.colorScheme) var colorScheme
    var type: String
    var creationTime: Date!
    var colour: UIColor? // Make colour optional
    
    var body: some View {
        let uiColour = colour ?? .systemGray6
        let displayColour = Color(uiColour)
        var contrastingTextColour = displayColour.contrastingTextColor()
        HStack {
            VStack(alignment: .leading) {
                Text(type)
                    .font(.headline)
                    .foregroundColor(contrastingTextColour)
                if ((creationTime) != nil) {
                    Text(creationTime, style: .date)
                        .font(.subheadline)
                        .foregroundColor(contrastingTextColour)
                }
            }
            .onAppear() {
                contrastingTextColour = displayColour.contrastingTextColor()
            }
            .foregroundColor(Color(.label))
            Spacer()
            Image(systemName: "chevron.right") // You can add an arrow or any other symbol to indicate a link
                .foregroundColor(contrastingTextColour)
        }
        .onChange(of: colorScheme) { newColour in
            contrastingTextColour = displayColour.contrastingTextColor()
        }
        .onAppear() {
            contrastingTextColour = displayColour.contrastingTextColor()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(displayColour))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(displayColour.isLightColor() ? Color.black.opacity(0.1) : Color.white.opacity(0.1), lineWidth: 1)
        )

    //    .background(colour)
        .cornerRadius(8)
        
    }
}

struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCard(type: "push", creationTime: Date(), colour: nil)
    }
}
