//
//  ExerciseDataTests.swift
//  ExerciseTrackerTests
//
//  Created by Madelaine Jones on 2023-10-08.
//

import XCTest
import CoreData
@testable import WorkoutTracker

class ExerciseDataTests: XCTestCase {

    var inTest: ExerciseData!
    var workoutData: WorkoutData!
    
    override func setUpWithError() throws {
        // Set up an in-memory Core Data stack
        let testDataManager = DataManager(container: NSPersistentContainer.inMemoryContainer)
        inTest = ExerciseData(dataManager: testDataManager)
        workoutData = WorkoutData(dataManager: testDataManager)
    }

    override func tearDownWithError() throws {
        inTest = nil
        workoutData = nil
    }

    
    func testCreateExercise() {
        let exerciseInfo = ExerciseInfo(creationTime: Date(), name: "Squats")
        let exercise = inTest.createExercise(exerciseInfo)
        
        XCTAssertNotNil(exercise)
        XCTAssertEqual(exercise.name, exerciseInfo.name)
        XCTAssertEqual(exercise.creationTime, exerciseInfo.creationTime)
    }

    
    func testUpdateExercise() {
        let initialInfo = ExerciseInfo(creationTime: Date(), name: "Squats")
        let exercise = inTest.createExercise(initialInfo)
        
        let updatedInfo = ExerciseInfo(creationTime: Date(), name: "Deadlifts")
        inTest.updateExercise(existingExercise: exercise, with: updatedInfo)
        
        XCTAssertEqual(exercise.name, updatedInfo.name)
    }

    func testGetAllExercises() {
        _ = inTest.createExercise(ExerciseInfo(creationTime: Date(), name: "Squats"))
        _ = inTest.createExercise(ExerciseInfo(creationTime: Date(), name: "Deadlifts"))
        
        let allExercises = inTest.getAllExercises()
        
        XCTAssertEqual(allExercises.count, 2)
    }
    
    func testGetExercisesByWorkoutId() {
        let workoutInfo = WorkoutInfo(creationTime: Date(), type: "Strength", template: nil)
        _ = workoutData.createWorkout(workoutInfo) // This method doesn't return a workout, so we fetch it afterwards
        
        guard let workout = workoutData.getAllWorkouts().first else {
            XCTFail("Failed to create workout")
            return
        }

        let exercise1 = inTest.createExercise(ExerciseInfo(creationTime: Date(), name: "Squats"))
        let exercise2 = inTest.createExercise(ExerciseInfo(creationTime: Date(), name: "Deadlifts"))
        
        inTest.addExercise(workoutId: workout.objectID, exercise: exercise1)
        inTest.addExercise(workoutId: workout.objectID, exercise: exercise2)
        
        let fetchedExercises = inTest.getExercises(workoutId: workout.objectID)
        
        XCTAssertEqual(fetchedExercises.count, 2)
    }


    
    func testGetExerciseById() {
        let exerciseInfo = ExerciseInfo(creationTime: Date(), name: "Squats")
        let createdExercise = inTest.createExercise(exerciseInfo)
        
        let fetchedExercise = inTest.getExerciseById(id: createdExercise.objectID)
        
        XCTAssertNotNil(fetchedExercise)
        XCTAssertEqual(fetchedExercise?.name, exerciseInfo.name)
    }

    func testAddExerciseToWorkout() {
        let workoutInfo = WorkoutInfo(creationTime: Date(), type: "Strength", template: nil)
        _ = workoutData.createWorkout(workoutInfo)
        
        guard let workout = workoutData.getAllWorkouts().first else {
            XCTFail("Failed to create workout")
            return
        }

        let exercise = inTest.createExercise(ExerciseInfo(creationTime: Date(), name: "Squats"))
        inTest.addExercise(workoutId: workout.objectID, exercise: exercise)
        
        let fetchedExercises = inTest.getExercises(workoutId: workout.objectID)
        
        XCTAssertEqual(fetchedExercises.count, 1)
    }


    func testDeleteExercise() {
        let exercise = inTest.createExercise(ExerciseInfo(creationTime: Date(), name: "Squats"))
        
        XCTAssertEqual(inTest.getAllExercises().count, 1)
        
        inTest.deleteExercise(exercise: exercise)
        
        XCTAssertEqual(inTest.getAllExercises().count, 0)
    }


}
