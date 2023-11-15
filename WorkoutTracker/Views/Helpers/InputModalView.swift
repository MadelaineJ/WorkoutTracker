//
//  SwiftUIView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-29.
//
import SwiftUI

struct InputModalView: View {
    @Binding var inputText: String
    var templates: [WorkoutTemplateModel]
    @Binding var selectedTemplate: WorkoutTemplateModel?
    @Binding var showTextField: Bool
    @Binding var selectedTab: Int
    
    var onSubmit: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                
                Text("Template")
                    .font(.title2)
                    .padding(.top)
                    .padding(.horizontal)
                if templates.count > 0 {
                    Picker(selection: $selectedTemplate, label: Text("Templates")) {
                        ForEach(templates, id: \.id) { template in
                            Text(template.type).tag(template as WorkoutTemplateModel?)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxHeight: 150)
                    .padding(.horizontal, 40)

                    Button(action: {
                        onSubmit()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Create Workout From Template")
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
            if !showTextField {
                Button("Create New Workout") {
                    self.showTextField = true
                    self.selectedTemplate = nil // Reset the template
                    self.inputText = ""
                }
                .padding()
            }
            
            if showTextField {
                Button(action: {
                    if !inputText.isEmpty {
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
                    FirstResponderTextField(text: $inputText, placeholder: "Enter Custom Workout Type", onCommit: {
                        if !inputText.isEmpty {
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
            self.inputText = selectedTemplate?.type ?? ""
            self.showTextField = false
        }
    }
}


struct InputModalView_Previews: PreviewProvider {
    @State static private var previewText: String = ""
    @State static private var previewSelectedTemplate: WorkoutTemplateModel? = nil
    @State static private var previewShowTextField: Bool = false
    @State static private var selectedTab: Int = 0
    
    static var previews: some View {
        InputModalView(inputText: $previewText,
                       templates: [],
                       selectedTemplate: $previewSelectedTemplate,
                       showTextField: $previewShowTextField, selectedTab: $selectedTab,
                       onSubmit: {
            print("Submit action from preview")
        })
    }
}
