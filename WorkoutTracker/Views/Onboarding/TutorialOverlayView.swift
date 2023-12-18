//
//  TutorialOverlayView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-12-01.
//

import SwiftUI

struct TutorialOverlayView: View {
    @Binding var showOverlay: Bool
    let lastStep: Int = 1
    var currentStep: Int
    var descriptionText: String // Text describing the current step

    var body: some View {
        if showOverlay {
            ZStack {
                // Clear background
            //    Color.clear.edgesIgnoringSafeArea(.all)
                Color(.systemGray6).opacity(0.50).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

                // Description
                VStack {
                    Spacer()
                    Text(descriptionText)
                        .padding()

                    Spacer()
                }

                // Close or next step button
                VStack {
                    Spacer()
                    Button(action: {
                        if currentStep == lastStep {
                            showOverlay = false
                        } else {
                            // Logic for next step
                        }
                    }) {
                        Text(currentStep == lastStep ? "Finish" : "Next")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

struct TutorialOverlayView_Previews: PreviewProvider {
    // Mock data for preview
    static let mockHighlightFrame = CGRect(x: 100, y: 100, width: 100, height: 50)
    static let mockDescriptionText = "This is a description for the highlighted area."

    static var previews: some View {
        // Create a state variable to simulate the binding
        StatefulPreviewWrapper(true) { showOverlay in
            TutorialOverlayView(showOverlay: showOverlay, currentStep: 1, descriptionText: mockDescriptionText)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

/// Helper struct to create a mutable state in previews
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private var content: (Binding<Value>) -> Content

    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
