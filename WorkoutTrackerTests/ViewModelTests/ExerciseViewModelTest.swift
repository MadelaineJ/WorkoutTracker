//
//  ExerciseViewModelTest.swift
//  WorkoutTrackerTests
//
//  Created by Madelaine Jones on 2023-10-22.
//

import XCTest
import CoreData
@testable import WorkoutTracker

class ExerciseViewModelTests: XCTestCase {

    var viewModel: ExerciseViewModel!
    var mockExerciseData: ExerciseData!
    var mockWorkoutData: WorkoutData!

    override func setUpWithError() throws {
        // Create an in-memory Core Data stack
        let testDataManager = DataManager(container: NSPersistentContainer.inMemoryContainer)
        mockExerciseData = ExerciseData(dataManager: testDataManager)
        mockWorkoutData = WorkoutData(dataManager: testDataManager)
        viewModel = ExerciseViewModel(controller: mockExerciseData)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockExerciseData = nil
        mockWorkoutData = nil
    }

    func testCreateExercise() {
        _ = viewModel.createExercise(name: "Squats")
        viewModel.getAllExercises()

        XCTAssertEqual(viewModel.exercises.count, 1)
        XCTAssertEqual(viewModel.exercises.first?.name, "Squats")
    }

    func testUpdateExercise() {
        let exercise = viewModel.createExercise(name: "Squats")
        viewModel.getAllExercises()
        let updatedInfo = ExerciseInfo(creationTime: Date(), name: "Deadlifts")
        viewModel.update(exercise: ExerciseModel(exercise: exercise), withNewInfo: updatedInfo)
        viewModel.getAllExercises()

        XCTAssertEqual(viewModel.exercises.first?.name, "Deadlifts")
    }

    func testGetAllExercises() {
        _ = viewModel.createExercise(name: "Squats")
        _ = viewModel.createExercise(name: "Deadlifts")
        viewModel.getAllExercises()

        XCTAssertEqual(viewModel.exercises.count, 2)
    }

    func testGetExercisesByWorkout() {
        let workoutInfo = WorkoutInfo(creationTime: Date(), type: "Strength")
        mockWorkoutData.createWorkout(workoutInfo)
        guard let workout = mockWorkoutData.getAllWorkouts().first else {
            XCTFail("Failed to create workout")
            return
        }
        
        _ = viewModel.createExercise(name: "Squats")
        let exercise = viewModel.createExercise(name: "Deadlifts")
        mockExerciseData.addExercise(workoutId: workout.objectID, exercise: exercise)

        viewModel.getExercises(workout: WorkoutModel(workout: workout))

        XCTAssertEqual(viewModel.exercises.count, 1)
    }

    func testAddExerciseToWorkout() {
        let workoutInfo = WorkoutInfo(creationTime: Date(), type: "Strength")
        mockWorkoutData.createWorkout(workoutInfo)
        guard let workout = mockWorkoutData.getAllWorkouts().first else {
            XCTFail("Failed to create workout")
            return
        }

        viewModel.addExercise(workout: WorkoutModel(workout: workout), name: "Squats")

        viewModel.getExercises(workout: WorkoutModel(workout: workout))

        XCTAssertEqual(viewModel.exercises.count, 1)
    }

    func testDeleteExercise() {
        let exercise = viewModel.createExercise(name: "Squats")
        viewModel.getAllExercises()
        
        viewModel.delete(ExerciseModel(exercise: exercise))
        
        viewModel.getAllExercises()
        XCTAssertEqual(viewModel.exercises.count, 0)
    }
}
