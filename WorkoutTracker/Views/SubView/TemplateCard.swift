//
//  TemplateCard.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-11-17.
//

import SwiftUI

struct TemplateCard: View {
    var workout: WorkoutTemplateModel
    var exercises: [ExerciseTemplateModel]
    var colour: Color
    
    var body: some View {
        
        VStack(alignment: .leading) {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(colour)
                        .cornerRadius(8)
                        .frame(height: 35)
                        .padding(.horizontal, -10)
                    HStack {
                        Text(workout.type)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .cornerRadius(8)
                }
            }
            Spacer()
            VStack {
                if exercises.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(exercises.prefix(3), id: \.id) { exercise in
                            Text(exercise.name)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }

                        if exercises.count > 3 {
                            Text("...") // Indicate more exercises
                                .foregroundColor(.secondary)
                        } else {
                            Text("")
                                .hidden()
                        }
                    }
                } else if (exercises.count == 0) {
                    Text("Click to add exercises")
                        .foregroundColor(.secondary)
                }
            }
            .frame(minHeight: 80)
        }
        .frame(height: 100) // Set a fixed height here
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
