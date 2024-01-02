//
//  WorkoutViewModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import Foundation
import CoreData
import UIKit

class WorkoutViewModel: ObservableObject {

    var controller: WorkoutData
    var exerciseViewModel: ExerciseViewModel = ExerciseViewModel()

    init(controller: WorkoutData = WorkoutData()) {
        self.controller = controller
        fetchAllUniqueWorkoutTypes()
    }

    var type = ""
    private var isSortedAscending = false
    
    @Published var workouts: [WorkoutModel] = []
    @Published var groupedWorkouts: [String: [WorkoutModel]] = [:]
    @Published var uniqueWorkoutTypes: [String] = []
    @Published var sortedMonths: [String] = []

    func createWorkout(type: String, colorData: Data? = nil, template: WorkoutTemplate?) -> Workout {
        
        // TODO: Remove testing code for adding workout from last month
//        let currentCalendar = Calendar.current
//        var dateComponents = DateComponents()
//        dateComponents.month = -1 // Subtract 1 month
//        let lastMonthDate = currentCalendar.date(byAdding: dateComponents, to: Date())
//
//        let workoutInfo = WorkoutInfo(creationTime: lastMonthDate ?? Date(), type: type, template: template)
        let workoutInfo = WorkoutInfo(creationTime: Date(), type: type, template: template)
        let workout = controller.createWorkout(workoutInfo, colorData: colorData)

        fetchAllUniqueWorkoutTypes()
        return workout
    }
    
    func fetchAllUniqueWorkoutTypes() {
        uniqueWorkoutTypes = controller.getAllUniqueWorkoutTypes()
    }
    
    func getAllWorkoutsByType(type: String) {
        workouts = controller.getAllWorkoutsByType(type: type).map(WorkoutModel.init)
    }

    func toggleWorkoutOrder(ascending: Bool) {
        isSortedAscending.toggle()
        workouts.sort(by: { ascending ? $0.creationTime < $1.creationTime : $0.creationTime > $1.creationTime })
    }

    
    func update(workout: WorkoutModel, withNewInfo newInfo: WorkoutInfo, color: UIColor? = nil) {
        if let existingWorkout = controller.getWorkoutById(id: workout.id) {
            controller.updateWorkout(existingWorkout: existingWorkout, with: newInfo, color: color)
        }
    }
    
    func getAllWorkouts() {
        workouts = controller.getAllWorkouts().sorted(by: { isSortedAscending ? $0.creationTime ?? Date() < $1.creationTime ?? Date() : $0.creationTime! > $1.creationTime! }).map(WorkoutModel.init)
    }


    func delete(_ workout: WorkoutModel) throws {
        let existingWorkout = controller.getWorkoutById(id: workout.id)
        if let existingWorkout = existingWorkout {
            try controller.deleteWorkout(workout: existingWorkout)
        }
    }

    func getColourForWorkout(workout: WorkoutModel) -> UIColor? {
        if let existingWorkout = controller.getWorkoutById(id: workout.id) {
            return controller.getColourForWorkout(workout: existingWorkout)
        }
        return nil
    }
    
    func groupedWorkoutsByMonth() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy" // Format the date to Month Year

        // Convert the month and year back to a Date for sorting
        let sortedWorkouts = workouts.sorted {
            guard let date1 = formatter.date(from: formatter.string(from: $0.creationTime)),
                  let date2 = formatter.date(from: formatter.string(from: $1.creationTime)) else {
                return false
            }
            return date1 > date2
        }


        // Group the sorted workouts
        let grouped = Dictionary(grouping: sortedWorkouts) { workout -> String in
            return formatter.string(from: workout.creationTime)
        }

        self.groupedWorkouts = grouped
        
        // 1. Convert the string keys back into Date objects for sorting
        self.sortedMonths = self.groupedWorkouts.keys.compactMap { monthString -> Date? in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter.date(from: monthString)
        }
        // 2. Sort the dates in descending order
        .sorted(by: { $0 > $1 })
        // 3. Map back to string format
        .map { date -> String in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: date)
        }
    }

}
