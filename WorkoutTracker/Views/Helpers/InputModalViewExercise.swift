//
//  InputModalViewExercise.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2024-02-20.
//

import SwiftUI

struct InputModalViewExercises: View {
    @Binding var inputText: String
    @Binding var isNameNotUnique: Bool
    var templates: [ExerciseTemplateModel]
    @Binding var selectedTemplate: ExerciseTemplateModel?
    @Binding var showTextField: Bool
    @Binding var selectedTab: Int
    var onSubmit: () -> Void
    var isNameValid: () -> Bool = { true }
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                
                Text("Templates")
                    .font(.title2)
                    .padding(.top)
                    .padding(.horizontal)
                if templates.count > 0 {
                    Picker(selection: $selectedTemplate, label: Text("Templates")) {
                        ForEach(templates) { template in
                            Text(template.name).tag(template as? ExerciseTemplateModel)

                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxHeight: 300)
                    .padding(.horizontal, 40)

                    Button(action: {
                        onSubmit()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Add Exercise From Template")
                    }
                    .padding(.top, 20)
                    
                    
                } else {
                    VStack {
                        Text("No templates to display")
                            .font(.headline)
                            .padding(.bottom, 2)

                        Text("Add new templates easily via the")
                            .padding(.bottom, 2)

                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            self.selectedTab = 1 // Set the selectedTab to navigate to the Templates tab
                        }) {
                            HStack {
                                Image(systemName: "square.grid.2x2")
                                    .foregroundColor(.accentColor)
                                    .padding(.trailing, 2)
                                Text("Templates Menu")
                                    .bold()
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                }



            }
            
            
            Text("Or")
                .padding(.top, 20)
            
            
            if isNameNotUnique {
                Text("Template names must be unique")
                    .foregroundColor(.red)
                    .padding()
            }
            if !showTextField {
                Button("Create New Exercise Template") {
                    self.showTextField = true
                    self.selectedTemplate = nil // Reset the template
                    self.inputText = ""
                }
                .padding()
            }
            
            if showTextField {
                Button(action: {
                    if !inputText.isEmpty && isNameValid() {
                        self.onSubmit()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Submit")
                }
                .disabled(inputText.isEmpty)
                .padding()

                ZStack {
                    Rectangle()
                    .foregroundColor(Color(.systemGray6))
                    .frame(maxHeight: 50)
                    .cornerRadius(8)
                    FirstResponderTextField(text: $inputText, placeholder: "Enter Custom Exercise Type", onCommit: {
                        if !inputText.isEmpty && isNameValid() {
                            self.onSubmit()
                            self.presentationMode.wrappedValue.dismiss() // Dismiss the modal
                        }
                    })
                    .padding()
                }
                .padding(.horizontal)
            }
        }
        .onAppear() {
            if !templates.isEmpty {
                self.selectedTemplate = templates.first
            }
            self.inputText = selectedTemplate?.name ?? ""
            self.showTextField = false
            isNameNotUnique = false  // Reset the flag
        }
    }
}

// You would also need to adjust the PreviewProvider for the new class
struct InputModalViewExercises_Previews: PreviewProvider {
    @State static private var previewText: String = ""
    @State static private var isNameNotUnique: Bool = false
    @State static private var previewSelectedTemplate: ExerciseTemplateModel? = nil
    @State static private var previewShowTextField: Bool = false
    @State static private var selectedTab: Int = 0
    
    static var previews: some View {
        InputModalViewExercises(inputText: $previewText, isNameNotUnique: $isNameNotUnique,
                                templates: [],
                                selectedTemplate: $previewSelectedTemplate,
                                showTextField: $previewShowTextField, selectedTab: $selectedTab,
                                onSubmit: {
            print("Submit action from preview")
        })
    }
}
