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
    
    var onSubmit: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                
                Text("Templates")
                    .font(.title2)
                    .padding(.top)
                    .padding(.horizontal)
                Picker(selection: $selectedTemplate, label: Text("Templates")) {
                    ForEach(templates, id: \.id) { template in
                        Text(template.type).tag(template as WorkoutTemplateModel?)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxHeight: 150)
                .padding(.horizontal, 40)
            }
            
            Button(action: {
                onSubmit()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Create Workout From Template")
            }
            .padding()
            .padding(.bottom, 10)
            
            Text("Or")
            
            if !showTextField {
                Button("Create New Workout") {
                    self.showTextField = true
                    self.selectedTemplate = nil // Reset the template
                    self.inputText = ""
                }
                .padding()
                .padding(.top, 10)
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
    
    static var previews: some View {
        InputModalView(inputText: $previewText,
                       templates: [],
                       selectedTemplate: $previewSelectedTemplate,
                       showTextField: $previewShowTextField,
                       onSubmit: {
            print("Submit action from preview")
        })
    }
}
