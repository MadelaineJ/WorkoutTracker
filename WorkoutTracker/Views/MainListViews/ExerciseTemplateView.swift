//
//  ExerciseTemplateView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-29.
//

import SwiftUI
import CoreData

struct ExerciseTemplateView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var viewModel: ExerciseTemplateViewModel
    @EnvironmentObject private var workoutViewModel: WorkoutTemplateViewModel
    @State private var isEditMode: EditMode = .inactive
    var workoutTemplate: WorkoutTemplateModel
    @State var editableWorkoutName: String
    @Binding var navigationPath: NavigationPath
    @Binding var selectedTab: Int
    
    @State private var isShowingInputModal = false
    @State private var inputText = ""
    @State private var isNameNotUnique = false
    @State private var selectedColor: Color = Color.white  // Color picker state variable
    @State private var showAlert: Bool = false
    @State private var isEditing: Bool = false  // State to control editing
    @State private var alertMessage: String = ""  // Alert message
    @FocusState private var isTextFieldFocused: Bool  // Focus state
    @State private var selectedTemplate: ExerciseTemplateModel? = nil
    @State private var showTextField: Bool = false

    var body: some View {
        VStack {
            HStack {
                InlineTextEditView(text: $editableWorkoutName, isEditing: $isEditing, isTextFieldFocused: $isTextFieldFocused, onCommit: {
                    if workoutNameExists(editableWorkoutName) {
                        alertMessage = "This workout name already exists. Please choose a different name."
                        showAlert = true
                        isEditing = true
                    } else {
                        let newInfo = WorkoutTemplateInfo(type: editableWorkoutName)
                        if let colour = workoutViewModel.getColorForWorkoutTemplate(workoutTemplateId: workoutTemplate.id) {
                            workoutViewModel.update(workoutTemplate: workoutTemplate, withNewInfo: newInfo, colour: colour)
                        } else {
                            workoutViewModel.update(workoutTemplate: workoutTemplate, withNewInfo: newInfo)
                        }
                        
                        isEditing = false
                    }
                })
                .font(.title)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Duplicate Name"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK")) {
                            // Force the user back to editing mode and focus the text field
                            isEditing = true
                            isTextFieldFocused = true
                        }
                    )
                }
                Spacer()
                DeleteButton(message: "Workout Template? \nThis action is irreversible! \n\n Deleting a template will not delete any workouts created from that template. But you will lose the ability to change their colour.") {
                    workoutViewModel.delete(workoutTemplate)
                    presentationMode.wrappedValue.dismiss()
                }
                    
            }
            .onAppear(perform: {
                editableWorkoutName = workoutTemplate.type

                // Fetch the UIColor from the workout template and convert it to SwiftUI Color
                if let workoutColor = workoutViewModel.getColorForWorkoutTemplate(workoutTemplateId: workoutTemplate.id) {
                    selectedColor = Color(workoutColor)
                }
            })
            .padding(.horizontal, 30)
            .padding(.top, 20)
             
            ZStack {
                HStack {
                    Button(action: {
                        self.isShowingInputModal.toggle()
                        
                    }) {
                        AddButton()
                    }
                    .background(Color.clear)
                    .cornerRadius(30)
                    .sheet(isPresented: $isShowingInputModal) {
                        InputModalViewExercises(inputText: $inputText, isNameNotUnique: $isNameNotUnique,
                                                templates: viewModel.returnAllExerciseTemplates(),
                                                selectedTemplate: $selectedTemplate,
                                                showTextField: $showTextField,
                                                selectedTab: $selectedTab,
                                                onSubmit: {
                                viewModel.addExerciseTemplate(workoutTemplate: workoutTemplate, name: inputText)
                                viewModel.getExerciseTemplates(workoutTemplate: workoutTemplate)
                            }, isNameValid: isTemplateNameUnique)
                    }
                }

                HStack {
                    Spacer()
                    ColorPicker("Select a colour", selection: $selectedColor)
                        .onChange(of: selectedColor) { newValue in
                            // Convert SwiftUI Color to UIColor
                            let uiColor = UIColor(newValue)
                            let newInfo = WorkoutTemplateInfo(type: editableWorkoutName)
                            workoutViewModel.update(workoutTemplate: workoutTemplate, withNewInfo: newInfo, colour: uiColor)
                        }
                        .labelsHidden()
                        .padding(.trailing, 25) // Adjust the padding value as needed
                        .scaleEffect(CGSize(width: 1.5, height: 1.5))
                }
            }

            if viewModel.exerciseTemplates.count != 0 {
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
                ForEach(viewModel.exerciseTemplates, id: \.id) { exercise in
                    ZStack {
                        ExerciseTemplateCard(type: exercise.name)
                    }
                }
                .onDelete(perform: deleteExercise)
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
        }
        .onChange(of: viewModel.exerciseTemplates.count) { newCount in
            if newCount == 0 && isEditMode == .active {
                isEditMode = .inactive
            }
        }
        .navigationBarItems(trailing: EditButton())
        .environment(\.editMode, $isEditMode)
        .onAppear(perform: {
            viewModel.getExerciseTemplates(workoutTemplate: workoutTemplate)
        })
        
    }
    func deleteExercise(at offsets: IndexSet) {
        offsets.forEach { index in
            let set = viewModel.exerciseTemplates[index] // get the set to be deleted
            viewModel.delete(set)
            viewModel.getExerciseTemplates(workoutTemplate: workoutTemplate)
            
        }
    }
    private func workoutNameExists(_ name: String) -> Bool {
        if name == workoutTemplate.type {
            print(workoutTemplate.type)
            return false
        } else {
            return workoutViewModel.workoutTemplates.contains { workout in
                workout.type == name
            }
        }
    }
    func isTemplateNameUnique() -> Bool {
        let isUnique = !viewModel.exerciseTemplates.contains(where: { $0.name.lowercased() == inputText.lowercased() })
        isNameNotUnique = !isUnique  // Set the state variable based on uniqueness
        return isUnique
    }
}

struct ExerciseTemplateView_Previews: PreviewProvider {
    @State static private var selectedTab: Int = 0
    static var previews: some View {
        
        let mockDataManager = DataManager(storeType: .inMemory)
        let mockDataController = ExerciseTemplateData(dataManager: mockDataManager)

        let entity = NSEntityDescription.entity(forEntityName: "WorkoutTemplate", in: mockDataManager.viewContext)!
        let workout = Workout(entity: entity, insertInto: mockDataManager.viewContext)
        workout.type = "Push"
        
        let mockDataWorkoutController = WorkoutTemplateData(dataManager: mockDataManager)
        let mockViewWorkoutModel = WorkoutTemplateViewModel(controller: mockDataWorkoutController)

        let navigationPath = NavigationPath()
        let mockViewModel = ExerciseTemplateViewModel(controller: mockDataController)
        return ExerciseListView(workout: WorkoutModel(workout: workout), selectedTab: $selectedTab, navigationPath: .constant(navigationPath))
            .environmentObject(mockViewModel)
            .environmentObject(mockViewWorkoutModel)
    }
}
