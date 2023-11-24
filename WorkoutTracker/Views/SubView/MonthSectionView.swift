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
            ForEach(workouts.indices, id: \.self) { index in
                if index == workouts.startIndex {
                    WorkoutCard(type: workouts[index].type, creationTime: workouts[index].creationTime, colour:
                                Color(viewModel.getColourForWorkout(workout: workouts[index]) ?? .systemGray6))
                        .padding(.top, 10)
                        .onTapGesture {
                            navigationPath.append(workouts[index])
                        }
                } else {
                    WorkoutCard(type: workouts[index].type, creationTime: workouts[index].creationTime, colour:
                                Color(viewModel.getColourForWorkout(workout: workouts[index]) ?? .systemGray6))
                    .onTapGesture {
                        navigationPath.append(workouts[index])
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
