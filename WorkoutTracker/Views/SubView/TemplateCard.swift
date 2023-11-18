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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(workout.type)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
            }
            Spacer()
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
        .frame(height: 100) // Set a fixed height here
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 3)
    }
}
