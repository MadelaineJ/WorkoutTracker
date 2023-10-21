//
//  WorkoutView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import SwiftUI

struct WorkoutListView: View {
    @EnvironmentObject private var viewModel: WorkoutViewModel
    
    @State private var isShowingInputModal = false
    @State private var inputText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    self.isShowingInputModal.toggle()
                }) {
                    AddButton()
                }
                .background(Color.clear)
                .cornerRadius(30)
                .sheet(isPresented: $isShowingInputModal) {
                    InputModalView(inputText: $inputText) {
                        viewModel.createWorkout(type: inputText)
                        viewModel.getAllWorkouts()
                    }
                }
                
                if viewModel.workouts.count == 0 {
                    Text("No Workouts To Display")
                }
                HStack {
                    if viewModel.workouts.count != 0 {
                        Text("Workouts")
                            .font(.title)
                    }
                    Spacer()
                }
                .padding(.horizontal, 30)

                    List {
                        ForEach(viewModel.workouts, id: \.id) { workout in
                            ZStack {
                                NavigationLink(destination: ExerciseListView(workout: workout)) {
                                    EmptyView()
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
          //  .navigationBarTitle("Workouts", displayMode: .large)
        }
        .background(Color(.systemGray2))

    }
    
    func deleteWorkout(at offsets: IndexSet) {
        offsets.forEach { index in
            let workout = viewModel.workouts[index] // get the set to be deleted
            viewModel.delete(workout)
            viewModel.getAllWorkouts()
        }
    }
}

struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockDataManager = DataManager(storeType: .inMemory)
        
        let mockDataWorkoutController = WorkoutData(dataManager: mockDataManager)
        let mockViewWorkoutModel = WorkoutViewModel(controller: mockDataWorkoutController)
        
        let mockDataExerciseController = ExerciseData(dataManager: mockDataManager)
        let mockViewExerciseModel = ExerciseViewModel(controller: mockDataExerciseController)
        
        return WorkoutListView()
            .environmentObject(mockViewWorkoutModel)
            .environmentObject(mockViewExerciseModel)
    }
}
