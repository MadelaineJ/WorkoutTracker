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
    var colour: UIColor?
    
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
                .stroke(contrastingTextColour.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(8)
        
    }
}

struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCard(type: "push", creationTime: Date(), colour: nil)
    }
}
