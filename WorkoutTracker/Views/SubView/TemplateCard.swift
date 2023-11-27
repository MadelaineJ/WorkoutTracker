//
//  TemplateCard.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-11-17.
//

import SwiftUI

struct TemplateCard: View {
    @Environment(\.colorScheme) var colorScheme
    var type: String
    var exercises: [ExerciseTemplateModel]
    var colour: UIColor? // Make colour optional
    
    var body: some View {
        var uiColour = colour ?? .systemGray6
        let displayColour = Color(uiColour)
        var contrastingTextColour = displayColour.contrastingTextColor()

        VStack(alignment: .leading) {
            VStack(spacing: 0) {
                HStack {
                    Text(type)
                        .font(.title3)
                        .foregroundColor(contrastingTextColour)
                    Spacer()
                }
                .padding(.bottom, 10)
                Divider()
                    .foregroundColor(contrastingTextColour)
                    .background(contrastingTextColour)
            }
            Spacer()
            VStack {
                if exercises.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(exercises.prefix(3), id: \.id) { exercise in
                            Text(exercise.name)
                                .font(.body)
                                .foregroundColor(contrastingTextColour)
                        }

                        if exercises.count > 3 {
                            Text("...") // Indicate more exercises
                                .foregroundColor(contrastingTextColour)
                        } else {
                            Text("")
                                .hidden()
                        }
                    }
                } else if (exercises.count == 0) {
                    Text("Click to add exercises")
                        .foregroundColor(contrastingTextColour)
                }
            }
            .frame(minHeight: 80)
        }
        .onAppear() {
            uiColour = colour ?? .systemGray6
            contrastingTextColour = displayColour.contrastingTextColor()
        }
        .onChange(of: colorScheme) { newColour in
            contrastingTextColour = displayColour.contrastingTextColor()
        }
        .frame(height: 100) // Set a fixed height here
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 8).fill(displayColour))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(contrastingTextColour.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func adjustedBackgroundColour(displayColour: Color) -> Color {
        return displayColour.isWhiteOrVeryLight() ? displayColour.adjustLightness(by: 0.05) : displayColour
    }
}
