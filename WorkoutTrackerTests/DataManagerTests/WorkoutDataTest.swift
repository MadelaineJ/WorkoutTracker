//
//  WorkoutDataTests.swift
//  WorkoutTrackerTests
//
//  Created by Madelaine Jones on 2023-10-08.
//

import XCTest
import CoreData
@testable import WorkoutTracker

class WorkoutDataTests: XCTestCase {

    var inTest: WorkoutData!
    
    override func setUpWithError() throws {
        // Set up an in-memory Core Data stack
        let container = NSPersistentContainer.inMemoryContainer
        let testDataManager = DataManager(container: container)
        inTest = WorkoutData(dataManager: testDataManager)
    }

    override func tearDownWithError() throws {
        inTest = nil
    }
    
    func testCreateWorkout() {
        // Given
        let workoutInfo = WorkoutInfo(creationTime: Date(), type: "Strength", template: nil)
        
        // When
        _ = inTest.createWorkout(workoutInfo)
        
        // Then
        let allWorkouts = inTest.getAllWorkouts()
        XCTAssertEqual(allWorkouts.count, 1, "Should have one workout after creation")
        XCTAssertEqual(allWorkouts.first?.type, workoutInfo.type, "The created workout's type should match the provided type")
    }
    
    func testUpdateWorkout() {
        // Given
        let workoutInfo = WorkoutInfo(creationTime: Date(), type: "Strength", template: nil)
        _ = inTest.createWorkout(workoutInfo)
        
        guard let existingWorkout = inTest.getAllWorkouts().first else {
            XCTFail("There should be an existing workout")
            return
        }
        
        let updatedInfo = WorkoutInfo(creationTime: Date(), type: "Cardio", template: nil)
        
        // When
        inTest.updateWorkout(existingWorkout: existingWorkout, with: updatedInfo)
        
        // Then
        let updatedWorkout = inTest.getWorkoutById(id: existingWorkout.objectID)
        XCTAssertEqual(updatedWorkout?.type, updatedInfo.type, "The updated workout's type should match the new type")
    }
    
    func testDeleteWorkout() {
        // Given
        let workoutInfo = WorkoutInfo(creationTime: Date(), type: "Strength", template: nil)
        _ = inTest.createWorkout(workoutInfo)
        
        guard let existingWorkout = inTest.getAllWorkouts().first else {
            XCTFail("There should be an existing workout")
            return
        }
        
        // When
        do {
            try inTest.deleteWorkout(workout: existingWorkout)
        } catch {
            XCTFail("Failed to delete the workout: \(error)")
        }
        
        // Then
        let allWorkouts = inTest.getAllWorkouts()
        XCTAssertEqual(allWorkouts.count, 0, "Should have no workouts after deletion")
    }
    
    func testGetAllWorkouts() {
        // Given
        let workoutInfo1 = WorkoutInfo(creationTime: Date(), type: "Strength", template: nil)
        let workoutInfo2 = WorkoutInfo(creationTime: Date(), type: "Cardio", template: nil)
        
        _ = inTest.createWorkout(workoutInfo1)
        _ = inTest.createWorkout(workoutInfo2)
        
        // When
        let allWorkouts = inTest.getAllWorkouts()
        
        // Then
        XCTAssertEqual(allWorkouts.count, 2, "Should retrieve two workouts")
    }
    
    func testGetAllWorkoutsByType() {
        // Given
        let workoutInfoStrength = WorkoutInfo(creationTime: Date(), type: "Strength", template: nil)
        let workoutInfoCardio = WorkoutInfo(creationTime: Date(), type: "Cardio", template: nil)
        _ = inTest.createWorkout(workoutInfoStrength)
        _ = inTest.createWorkout(workoutInfoCardio)
        
        // When
        let strengthWorkouts = inTest.getAllWorkoutsByType(type: "Strength")
        let cardioWorkouts = inTest.getAllWorkoutsByType(type: "Cardio")
        
        // Then
        XCTAssertEqual(strengthWorkouts.count, 1, "Should retrieve one workout of type 'Strength'")
        XCTAssertEqual(strengthWorkouts.first?.type, "Strength", "The retrieved workout's type should be 'Strength'")
        XCTAssertEqual(cardioWorkouts.count, 1, "Should retrieve one workout of type 'Cardio'")
        XCTAssertEqual(cardioWorkouts.first?.type, "Cardio", "The retrieved workout's type should be 'Cardio'")
        
        // Testing for no results with an unused type
        let yogaWorkouts = inTest.getAllWorkoutsByType(type: "Yoga")
        XCTAssertTrue(yogaWorkouts.isEmpty, "Should retrieve no workouts of type 'Yoga'")
    }

    
    func testGetWorkoutById() {
        // Given
        let workoutInfo = WorkoutInfo(creationTime: Date(), type: "Strength", template: nil)
        _ = inTest.createWorkout(workoutInfo)
        
        guard let existingWorkout = inTest.getAllWorkouts().first else {
            XCTFail("There should be an existing workout")
            return
        }
        
        // When
        let retrievedWorkout = inTest.getWorkoutById(id: existingWorkout.objectID)
        
        // Then
        XCTAssertNotNil(retrievedWorkout, "Should retrieve a workout by its ID")
        XCTAssertEqual(retrievedWorkout?.type, workoutInfo.type, "The retrieved workout's type should match the original type")
    }
}
