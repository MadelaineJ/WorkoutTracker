//
//  WorkoutView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import SwiftUI

struct WorkoutView: View {
    @StateObject private var viewModel = WorkoutViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    viewModel.createWorkout()
                    viewModel.getAllWorkouts()
                    print("creatingworkout")
                }) {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color(.systemIndigo))
                            .padding()
                        
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                }
                .background(Color.clear)
                .cornerRadius(30)
                    List {
                        ForEach(viewModel.workouts, id: \.id)  {workout in
                            ZStack {
                                NavigationLink(destination: ExerciseList()) {
                                    EmptyView() // Empty view so it doesn't affect your design
                                }
                                .opacity(0) // Make it invisible
                                
                                WorkoutCard(type: workout.type, creationTime: workout.creationTime)
                            }
                            
                        }
                        .onDelete(perform: deleteWorkout)
                        .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                
                
            }
            .onAppear(perform: {
                viewModel.getAllWorkouts()
            })
        }
        .background(Color(.systemGray2))

    }
    
    func deleteWorkout(at offsets: IndexSet) {
        offsets.forEach { index in
            let set = viewModel.workouts[index] // get the set to be deleted
            viewModel.delete(set)
            
        }
    }
}


struct WorkoutView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        WorkoutView()
    }
}
