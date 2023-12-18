//
//  OnboardingView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-12-01.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingActive: Bool

    var body: some View {
        TabView {
            VStack(spacing: 20) {
                Text("Welcome to FitStats!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your personal workout tracker")
                    .font(.title2)
                
                // Add more content as needed

                Button(action: {
                    // When the user taps "Get Started", onboarding should be dismissed
                    isOnboardingActive = false
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}


#Preview {
    OnboardingView(isOnboardingActive: .constant(true))
}
