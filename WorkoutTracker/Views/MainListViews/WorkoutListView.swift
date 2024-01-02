//
//  WorkoutView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import SwiftUI

struct WorkoutListView: View {
    @EnvironmentObject private var viewModel: WorkoutViewModel
    @EnvironmentObject private var templateViewModel: WorkoutTemplateViewModel
    
    @Binding var selectedTab: Int
    
    @State private var isShowingInputModal = false
    @State private var selectedTemplate: WorkoutTemplateModel? = nil
    @State private var showTextField: Bool = false
    @State private var isSortedAscending = false
    @State private var inputText = ""
    @State private var selectedWorkoutType: String? = nil
    @State private var isEditMode: EditMode = .inactive
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                
                HStack {
                        Text("Workouts")
                            .font(.title)
                    Spacer()
                }
                .padding(.horizontal, 30)
                HStack {
                    
                    Button(action: {
                        self.isShowingInputModal.toggle()
                        selectedWorkoutType = nil
                    }) {
                        AddButton()
                    }
                    .background(Color.clear)
                    .cornerRadius(30)
                    .sheet(isPresented: $isShowingInputModal) {
                        InputModalView(inputText: $inputText,
                                       templates: templateViewModel.workoutTemplates,
                                       selectedTemplate: $selectedTemplate,
                                       showTextField: $showTextField,
                                       selectedTab: $selectedTab) {
                            var newWorkout: WorkoutModel
                            if self.showTextField {
                                newWorkout = WorkoutModel(workout: viewModel.createWorkout(type: inputText, template: nil))
                                navigationPath.append(newWorkout)
                            } else if let template = self.selectedTemplate {
                                newWorkout = WorkoutModel(workout: templateViewModel.createWorkoutFromTemplate(workoutTemplate: template))
                                navigationPath.append(newWorkout)
                            }
                            viewModel.getAllWorkouts()
                        }
                    }
                }
                .padding(.horizontal, 30)
                
                HStack {
                    if viewModel.workouts.count != 0 {

                    Spacer()
                    // The Filtering Button
                        HStack() {
                            Menu("Filter") {
                                
                                ForEach(viewModel.uniqueWorkoutTypes, id: \.self) { type in
                                    Button(type) {
                                        selectedWorkoutType = type
                                        filterWorkouts(byType: type)
                                    }
                                }
                            //    Button("Clear Filters", action: clearFilters)
                            }
                            .onAppear(){
                                viewModel.fetchAllUniqueWorkoutTypes()
                            }
                            
                            // X button to clear filters, visible only when a filter is selected
                            if selectedWorkoutType != nil {
                                Button(action: clearFilters) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 5)

                if viewModel.workouts.count == 0 {
                    Text("No Workouts To Display")
                }
                List {
                    ForEach(viewModel.sortedMonths, id: \.self) { month in
    
                        MonthSectionView(navigationPath: $navigationPath, month: month, workouts: viewModel.groupedWorkouts[month] ?? [])
                    }

                }
                .listStyle(PlainListStyle())
                .navigationBarItems(trailing: EditButton())
                .environment(\.editMode, $isEditMode)
                .padding(.bottom, 25)
                .onAppear(perform: {
                    viewModel.getAllWorkouts()
                    viewModel.groupedWorkoutsByMonth()
                })

            }
            .onAppear(perform: {
                   viewModel.getAllWorkouts()
                   isEditMode = .inactive
            })
            .navigationDestination(for: WorkoutModel.self) { workout in
                ExerciseListView(workout: workout, navigationPath: $navigationPath)
            }
            .onChange(of: viewModel.workouts.count) { newCount in
                if newCount == 0 && isEditMode == .active {
                    isEditMode = .inactive
                }
            }
            .onAppear(perform: {
                viewModel.getAllWorkouts()
            })
        }
        .background(Color(.white))
        .onAppear(perform: {
            templateViewModel.getAllWorkoutTemplates()
            if let firstTemplate = templateViewModel.workoutTemplates.first {
                self.selectedTemplate = firstTemplate
            }
        })
    }
    
    func filterWorkouts(byType type: String?) {
        viewModel.getAllWorkoutsByType(type: type!) // This will update viewModel.workouts
        viewModel.groupedWorkoutsByMonth() // Update groupedWorkouts based on the filtered workouts
    }
    
    // Clears the selected workout type and gets all workouts
    func clearFilters() {
        selectedWorkoutType = nil
        viewModel.getAllWorkouts()
        viewModel.groupedWorkoutsByMonth() // Reset groupedWorkouts
    }


}

struct WorkoutListView_Previews: PreviewProvider {
    @State static private var selectedTab: Int = 0

    static var previews: some View {
        let mockDataManager = DataManager(storeType: .inMemory)
        
        let mockDataWorkoutController = WorkoutData(dataManager: mockDataManager)
        let mockViewWorkoutModel = WorkoutViewModel(controller: mockDataWorkoutController)
        
        let mockDataWorkoutTemplateController = WorkoutTemplateData(dataManager: mockDataManager)
        let mockViewWorkoutTemplateModel = WorkoutTemplateViewModel(controller: mockDataWorkoutTemplateController)
        
        return WorkoutListView(selectedTab: $selectedTab)
            .environmentObject(mockViewWorkoutModel)
            .environmentObject(mockViewWorkoutTemplateModel)
    }
}
