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
    
    var workout: WorkoutModel
    
    @State private var isShowingInputModal = false
    @State private var inputText = ""

    var body: some View {
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
                    viewModel.addExercise(workout: workout, name: inputText)
                    viewModel.getExercises(workout: workout)
                }
            }
            if viewModel.exercises.count == 0 {
                Text("No Exercise To Display")
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
        .navigationBarTitle("\(workout.type) Exercises", displayMode: .large)
        
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

        
        let mockViewModel = ExerciseViewModel(controller: mockDataController)
        return ExerciseListView(workout: WorkoutModel(workout: workout))
            .environmentObject(mockViewModel)
    }
}
