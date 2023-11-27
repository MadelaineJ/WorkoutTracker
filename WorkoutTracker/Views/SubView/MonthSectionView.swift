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
    var deleteAction: (IndexSet) -> Void

    var body: some View {
        Section(
            header: Text(month).font(.title3)
        ) {
            ForEach(workouts, id: \.self) { workout in
                HStack {
                    WorkoutCard(type: workout.template?.type ?? workout.type, creationTime: workout.creationTime, colour:
                                viewModel.getColourForWorkout(workout: workout))
                        .padding(.top, workout == workouts.first ? 10 : 0)
                        .onTapGesture {
                            navigationPath.append(workout)
                        }
                }
            }
            .onDelete(perform: deleteAction)
            .listRowSeparator(.hidden)
            .listSectionSeparator(.visible, edges: .top) // This will show the divider only below the header

        }
    }
}



//struct MonthSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        MonthSectionView(month: <#String#>, workouts: <#[WorkoutModel]#>)
//    }
//}
