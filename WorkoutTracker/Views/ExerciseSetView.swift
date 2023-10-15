//
//  SetView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import SwiftUI
import CoreData

struct ExerciseSetView: View {
    @StateObject private var viewModel = ExerciseSetViewModel()
    
    var body: some View {
        
        VStack(spacing: 16) {
            TextField("Reps", text: $viewModel.reps)
                .keyboardType(.numberPad)
                .padding()
                .border(Color.gray, width: 0.5)
            
            TextField("Weight", text: $viewModel.weight)
                .keyboardType(.numberPad)
                .padding()
                .border(Color.gray, width: 0.5)
            
            Button(action: {
                viewModel.createExerciseSet()
                viewModel.getAllSets()
            }) {
                Text("Add Set")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Text("LIST")
            List {
                ForEach(viewModel.exerciseSets, id: \.id) { exerciseSet in
                    Text(String(exerciseSet.reps))
                    Text(String(exerciseSet.weight))
                }
                .onDelete(perform: deleteSet)
            }
            
            Spacer()
        }
        .padding()
        .onAppear(perform: {
            viewModel.getAllSets()
        })

    }
    
    func deleteSet(at offsets: IndexSet) {
        offsets.forEach { index in
            let set = viewModel.exerciseSets[index] // get the set to be deleted
            viewModel.delete(set)
            
        }
    }
    
    
    
    
}

struct SetView_Previews: PreviewProvider {

    static var previews: some View {
        ExerciseSetView()
    }
}

