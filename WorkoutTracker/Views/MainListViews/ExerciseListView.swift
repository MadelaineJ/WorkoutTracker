//
//  WorkoutDetails.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-14.
//

import SwiftUI
import CoreData

struct ExerciseListView: View {
    
    @EnvironmentObject private var viewModel: ExerciseViewModel
    @EnvironmentObject private var workoutViewModel: WorkoutViewModel
    
    var workout: WorkoutModel
    
    @State private var isShowingInputModal = false
    @State private var inputText = ""
    @State private var editableWorkoutName: String = ""

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                InlineTextEditView(text: $editableWorkoutName)
                    .font(.title)
                    .padding(.horizontal, 30)
                Spacer()
            }
            .onAppear(perform: {
                editableWorkoutName = workout.type
            })
            .onChange(of: editableWorkoutName) { newValue in
                let newInfo = WorkoutInfo(creationTime: workout.creationTime, type: newValue)
                workoutViewModel.update(workout: workout, withNewInfo: newInfo)
            }
            
            Button(action: {
                self.isShowingInputModal.toggle()
                
            }) {
                AddButton()
            }
            .background(Color.clear)
            .cornerRadius(30)
            .sheet(isPresented: $isShowingInputModal) {
                SimpleInputModalView(inputText: $inputText) {
                    viewModel.addExercise(id: workout.id, name: inputText)
                    viewModel.getExercises(workout: workout)
                }
            }
            
            if viewModel.exercises.count != 0 {
                VStack {
                    HStack {
                        Text("Exercises")
                            .font(.title2)
                            .padding(.leading, 30)
                        Spacer()
                    }
                    Divider()
                        .padding(.horizontal)
                }

            } else {
                Text("No Exercises To Display")
                    .padding(.vertical, 20)
            }

            List {
                ForEach(viewModel.exercises, id: \.id) { exercise in
                    ZStack {
                        NavigationLink(destination: SetListView(exercise: exercise)) {
                            EmptyView()
                        }
                        WorkoutCard(type: exercise.name, creationTime: exercise.creationTime)
                    }
                }
                .onDelete(perform: deleteExercise)
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
        }
        .onAppear(perform: {
            viewModel.getExercises(workout: workout)
        })
        
    }
    func deleteExercise(at offsets: IndexSet) {
        offsets.forEach { index in
            let set = viewModel.exercises[index] // get the set to be deleted
            viewModel.delete(set)
            viewModel.getExercises(workout: workout)
            
        }
    }
}

struct ExerciseListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let mockDataManager = DataManager(storeType: .inMemory)
        let mockDataController = ExerciseData(dataManager: mockDataManager)
        

        let entity = NSEntityDescription.entity(forEntityName: "Workout", in: mockDataManager.viewContext)!
        let workout = Workout(entity: entity, insertInto: mockDataManager.viewContext)
        workout.type = "Push"
        
        let mockDataWorkoutController = WorkoutData(dataManager: mockDataManager)
        let mockViewWorkoutModel = WorkoutViewModel(controller: mockDataWorkoutController)

        
        let mockViewModel = ExerciseViewModel(controller: mockDataController)
        return ExerciseListView(workout: WorkoutModel(workout: workout))
            .environmentObject(mockViewModel)
            .environmentObject(mockViewWorkoutModel)
    }
}
