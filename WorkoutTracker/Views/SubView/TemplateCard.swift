//
//  TemplateCard.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-11-17.
//

import SwiftUI

struct TemplateCard: View {
    var type: String
    var exercises: [ExerciseTemplateModel]
    var colour: Color
    
    var body: some View {
        
        VStack(alignment: .leading) {
            VStack(spacing: 0) {
                HStack {
                    Text(type)
                        .font(.title3)
                        .foregroundColor(colour.contrastingTextColor())
                    Spacer()
                }
                .padding(.bottom, 10)
                Divider()
                    .foregroundColor(colour.contrastingTextColor())
                    .background(colour.contrastingTextColor())
            }
            Spacer()
            VStack {
                if exercises.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(exercises.prefix(3), id: \.id) { exercise in
                            Text(exercise.name)
                                .font(.body)
                                .foregroundColor(colour.contrastingTextColor())
                        }

                        if exercises.count > 3 {
                            Text("...") // Indicate more exercises
                                .foregroundColor(colour.contrastingTextColor())
                        } else {
                            Text("")
                                .hidden()
                        }
                    }
                } else if (exercises.count == 0) {
                    Text("Click to add exercises")
                        .foregroundColor(colour.contrastingTextColor())
                }
            }
            .frame(minHeight: 80)
        }
      
        .frame(height: 100) // Set a fixed height here
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 8).fill(adjustedBackgroundColour()))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(colour.isLightColor() ? Color.black.opacity(0.1) : Color.white.opacity(0.1), lineWidth: 1)
        )
        
   //     .background(Color(.systemGray6))
    }
    
    private func adjustedBackgroundColour() -> Color {
        return colour.isWhiteOrVeryLight() ? colour.adjustLightness(by: 0.05) : colour
    }
}
