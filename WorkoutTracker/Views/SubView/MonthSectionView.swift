//
//  MonthSectionView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-11-24.
//

import SwiftUI

struct MonthSectionView: View {
    @EnvironmentObject private var viewModel: WorkoutViewModel
    @Binding var navigationPath: NavigationPath
    var month: String
    var workouts: [WorkoutModel]

    var body: some View {
        Section(
            header: Text(month).font(.title3)
        ) {
            ForEach(workouts, id: \.id) { workout in
                HStack {
                    WorkoutCard(type: workout.template?.type ?? workout.type, creationTime: workout.creationTime, colour:
                                viewModel.getColourForWorkout(workout: workout))
                        .onTapGesture {
                            navigationPath.append(workout)
                        }
                        .onAppear() {
                            viewModel.getAllWorkouts()
                        }
                }
            }

            .onDelete(perform: deleteWorkout)
            .listRowSeparator(.hidden)
            .listSectionSeparator(.visible, edges: .top) // This will show the divider only below the header

        }
    }
    
    
    func deleteWorkout(at offsets: IndexSet) {
        
        offsets.forEach { index in
        let workout = viewModel.workouts[index] // get the set to be deleted
        do {
            try viewModel.delete(workout)
        } catch {
            // Handle or log the error if needed
            print("Error occurred while deleting workout: \(error.localizedDescription)")
        }
           // viewModel.delete(workout)
            viewModel.getAllWorkouts() // Refresh data
            viewModel.groupedWorkoutsByMonth()
        }

    }
}



//struct MonthSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        MonthSectionView(month: <#String#>, workouts: <#[WorkoutModel]#>)
//    }
//}
