//
//  WorkoutViewModelTest.swift
//  WorkoutTrackerTests
//
//  Created by Madelaine Jones on 2023-10-22.
//

import XCTest
import CoreData
@testable import WorkoutTracker

class WorkoutViewModelTests: XCTestCase {

    var viewModel: WorkoutViewModel!
    var mockWorkoutData: WorkoutData!

    override func setUpWithError() throws {
        // Create an in-memory Core Data stack
        let testDataManager = DataManager(container: NSPersistentContainer.inMemoryContainer)
        mockWorkoutData = WorkoutData(dataManager: testDataManager)
        viewModel = WorkoutViewModel(controller: mockWorkoutData)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockWorkoutData = nil
    }

    func testCreateWorkout() {
        _ = viewModel.createWorkout(type: "Strength", template: nil)
        viewModel.getAllWorkouts()

        XCTAssertEqual(viewModel.workouts.count, 1)
        XCTAssertEqual(viewModel.workouts.first?.type, "Strength")
    }

    func testUpdateWorkout() {
        _ = viewModel.createWorkout(type: "Strength", template: nil)
        viewModel.getAllWorkouts()
        guard let firstWorkout = viewModel.workouts.first else {
            XCTFail("No workout found")
            return
        }
        let updatedInfo = WorkoutInfo(creationTime: Date(), type: "Cardio", template: nil)
        viewModel.update(workout: firstWorkout, withNewInfo: updatedInfo)
        viewModel.getAllWorkouts()

        XCTAssertEqual(viewModel.workouts.first?.type, "Cardio")
    }
    

    func testGetAllWorkouts() {
        _ = viewModel.createWorkout(type: "Strength", template: nil)
        _ = viewModel.createWorkout(type: "Cardio", template: nil)
        viewModel.getAllWorkouts()

        XCTAssertEqual(viewModel.workouts.count, 2)
    }

    func testDeleteWorkout() {
        _ = viewModel.createWorkout(type: "Strength", template: nil)
        viewModel.getAllWorkouts()
        guard let firstWorkout = viewModel.workouts.first else {
            XCTFail("No workout found")
            return
        }
        do {
            try viewModel.delete(firstWorkout)
            viewModel.getAllWorkouts()
            XCTAssertEqual(viewModel.workouts.count, 0)
        } catch {
            XCTFail("Delete operation failed with error: \(error)")
        }
    }
    
}
