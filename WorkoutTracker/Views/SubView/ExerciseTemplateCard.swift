//
//  ExerciseTemplateCard.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-29.
//

import SwiftUI

struct ExerciseTemplateCard: View {
    var type: String
    var creationTime: Date!
    
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
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        
    }
}

struct ExerciseTemplateCard_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseTemplateCard(type: "Push", creationTime: Date())
    }
}
