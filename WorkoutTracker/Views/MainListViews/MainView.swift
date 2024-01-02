//
//  MainView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-29.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @State private var isOnboardingActive = !UserDefaults.standard.bool(forKey: "didCompleteOnboarding")

    var body: some View {
        if isOnboardingActive {
            OnboardingMainView(isOnboardingActive: $isOnboardingActive)
                .onDisappear {
                    // Set the UserDefaults flag when onboarding is completed
                    if !isOnboardingActive {
                        UserDefaults.standard.set(true, forKey: "didCompleteOnboarding")
                    }
                }
        } else {
            VStack {
                TabView(selection: $selectedTab) {
                    WorkoutListView(selectedTab: $selectedTab)
                        .tabItem {
                            Label("Workouts", systemImage: "list.bullet")
                        }
                        .tag(0)

                    WorkoutTemplateView()
                        .tabItem {
                            Label("Templates", systemImage: "square.grid.2x2")
                        }
                        .tag(1)
                }
                .background(Color.white)
            }
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let mockDataManager = DataManager(storeType: .inMemory)
        
        let mockDataWorkoutController = WorkoutData(dataManager: mockDataManager)
        let mockViewWorkoutModel = WorkoutViewModel(controller: mockDataWorkoutController)
        
        let mockDataExerciseController = ExerciseData(dataManager: mockDataManager)
        let mockViewExerciseModel = ExerciseViewModel(controller: mockDataExerciseController)
        
        let mockDataWorkoutTemplateController = WorkoutTemplateData(dataManager: mockDataManager)
        let mockViewWorkoutTemplateModel = WorkoutTemplateViewModel(controller: mockDataWorkoutTemplateController)
        MainView()
            .environmentObject(mockViewWorkoutModel)
            .environmentObject(mockViewExerciseModel)
            .environmentObject(mockViewWorkoutTemplateModel)
    }
}
