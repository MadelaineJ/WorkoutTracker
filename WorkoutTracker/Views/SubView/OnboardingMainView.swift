//
//  OnboardingView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-12-18.
//

import SwiftUI

struct OnboardingMainView: View {
    @Binding var isOnboardingActive: Bool
    @State private var currentStep = 0
    private let imageList = ["step0", "step1", "step2", "step3", "step5", "step6", "step7", "step8", "step9"]
    private let lastStep = 8

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // The background image of the app.
                Image(imageList[currentStep])
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all) // Make the image extend into the safe area
                    .background(Color.white)

                // Overlay a view that matches the safe area to hide the screenshot's duplicated status bar. For Top of safe area
                VStack {
                    Color.black.opacity(0.2)
                        .frame(height: geometry.safeAreaInsets.top)
                        .background(Color(.white)) // Use the same background color as the app
                        .edgesIgnoringSafeArea(.top)

                    Spacer() // This will push the safe area cover to the top
                }
                // Overlay for the bottom of safe area
                VStack {
                    Spacer() // This will push the safe area cover to the bottom
                    Color.black.opacity(0.2)
                        .frame(height: geometry.safeAreaInsets.top)
                        .background(Color(.white)) // Specified so that it's in the same in dark and light mode
                        .edgesIgnoringSafeArea(.bottom)
                }
                VStack {
                    Spacer()
                    VStack {
                        Text("Step \(currentStep + 1) of \(imageList.count)")
                            .font(.headline)
                            .foregroundColor(.black)

                        HStack {
                            Spacer()
                            // Back Button
                            if currentStep > 0 {
                                Button(action: {
                                    if (currentStep > 0) {
                                        currentStep -= 1
                                    }
                                }) {
                                    Text("Back")
                                        .font(.headline)
                                        .padding()
                                        .background(Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            // Next & Get Started Button
                            Button(action: {
                                if currentStep < lastStep {
                                    currentStep += 1
                                } else {
                                    isOnboardingActive = false
                                }
                            }) {
                                Text(currentStep < lastStep ? "Next" : "Get Started")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    .padding(.top, 25)
                    .background(
                        Rectangle()
                            .fill(.white)
                        .cornerRadius(30)
                        .padding(.horizontal, 70)
                        
                    )
                }
                .padding(.bottom, 130)
                
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }

}


#Preview {
    OnboardingMainView(isOnboardingActive: .constant(true))
}
