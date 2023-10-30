//
//  WorkoutTemplateView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-29.
//

import SwiftUI

struct WorkoutTemplateView: View {
    @EnvironmentObject private var viewModel: WorkoutTemplateViewModel
    
    @State private var isShowingInputModal = false
    @State private var inputText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                        Text("Workout Templates")
                            .font(.title)
                    Spacer()
                }
                .padding(.horizontal, 30)
                
                
                Button(action: {
                    self.isShowingInputModal.toggle()
                }) {
                    AddButton()
                }
                .background(Color.clear)
                .cornerRadius(30)
                .sheet(isPresented: $isShowingInputModal) {
                    SimpleInputModalView(inputText: $inputText) {
                        viewModel.createWorkoutTemplate(type: inputText)
                        viewModel.getAllWorkoutTemplates()
                    }
                }
                
                if viewModel.workoutTemplates.count == 0 {
                    Text("No Workout Templates")
                }
                    List {
                        ForEach(viewModel.workoutTemplates, id: \.id) { workout in
                            ZStack {
                                NavigationLink(destination: ExerciseTemplateView(workoutTemplate: workout)) {
                                    EmptyView()
                                }
                                .opacity(0) // Make it invisible
                                WorkoutCard(type: workout.type)
                            }
                            
                        }
                        .onDelete(perform: deleteWorkout)
                        .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
            .onAppear(perform: {
                viewModel.getAllWorkoutTemplates()
            })
        }
        .background(Color(.systemGray2))

    }
    
    
    func deleteWorkout(at offsets: IndexSet) {
        offsets.forEach { index in
            guard viewModel.workoutTemplates.indices.contains(index) else { return } // Safely check if the index is valid
            
            let workout = viewModel.workoutTemplates[index] // get the set to be deleted
            viewModel.delete(workout)
            
            viewModel.getAllWorkoutTemplates()
        }
    }
}

struct TemplateView_Previews: PreviewProvider {
    static var previews: some View {
        let mockDataManager = DataManager(storeType: .inMemory)
        
        let mockDataWorkoutController = WorkoutTemplateData(dataManager: mockDataManager)
        let mockViewWorkoutModel = WorkoutTemplateViewModel(controller: mockDataWorkoutController)
        
        
        return WorkoutTemplateView()
            .environmentObject(mockViewWorkoutModel)
    }
}
