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
            Button("Create New") {
                self.showTextField = true
                self.selectedTemplate = nil // Reset the template
                self.inputText = ""
            }
            .padding()
            
            Divider()
            
            if showTextField {
                FirstResponderTextField(text: $inputText, placeholder: "Enter Custom Workout Type", onCommit: {
                    self.onSubmit()
                    self.presentationMode.wrappedValue.dismiss() // Dismiss the modal
                })
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
            } else {
                Picker(selection: $selectedTemplate, label: Text("Select Template")) {
                    ForEach(templates, id: \.id) { template in
                        Text(template.type).tag(template as WorkoutTemplateModel?)
                    }
                }
                .labelsHidden()
                .pickerStyle(WheelPickerStyle())
                .padding()
            }
            
            Button(action: {
                onSubmit()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Submit")
            }
            .padding()
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
