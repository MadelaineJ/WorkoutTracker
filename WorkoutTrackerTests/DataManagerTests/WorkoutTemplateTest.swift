//
//  WorkoutTemplateTest.swift
//  WorkoutTrackerTests
//
//  Created by Madelaine Jones on 2023-10-28.
//

import XCTest
import CoreData
@testable import WorkoutTracker

class WorkoutTemplateDataTests: XCTestCase {

    var inTest: WorkoutTemplateData!
    
    override func setUpWithError() throws {
        // Set up an in-memory Core Data stack
        let container = NSPersistentContainer.inMemoryContainer
        let testDataManager = DataManager(container: container)
        inTest = WorkoutTemplateData(dataManager: testDataManager)
    }

    override func tearDownWithError() throws {
        inTest = nil
    }
    
    func testCreateWorkoutTemplate() {
        // Given
        let workoutType = "Strength"
        
        // When
        inTest.createWorkoutTemplate(workoutType)
        
        // Then
        let allWorkoutTemplates = inTest.getAllWorkoutTemplates()
        XCTAssertEqual(allWorkoutTemplates.count, 1, "Should have one workout template after creation")
        XCTAssertEqual(allWorkoutTemplates.first?.type, workoutType, "The created workout template's type should match the provided type")
    }
    
    func testUpdateWorkoutTemplate() {
        // Given
        let workoutType = "Strength"
        inTest.createWorkoutTemplate(workoutType)
        
        guard let existingWorkoutTemplate = inTest.getAllWorkoutTemplates().first else {
            XCTFail("There should be an existing workout template")
            return
        }
        
        let updatedType = "Cardio"
        let updatedInfo = WorkoutTemplateInfo(type: updatedType)
        
        // When
        inTest.updateWorkoutTemplate(existingWorkoutTemplate: existingWorkoutTemplate, with: updatedInfo)
        
        // Then
        let updatedWorkoutTemplate = inTest.getWorkoutTemplateById(id: existingWorkoutTemplate.objectID)
        XCTAssertEqual(updatedWorkoutTemplate?.type, updatedType, "The updated workout template's type should match the new type")
    }
    
    func testDeleteWorkoutTemplate() {
        // Given
        let workoutType = "Strength"
        inTest.createWorkoutTemplate(workoutType)
        
        guard let existingWorkoutTemplate = inTest.getAllWorkoutTemplates().first else {
            XCTFail("There should be an existing workout template")
            return
        }
        
        // When
        do {
            try inTest.deleteWorkoutTemplate(workoutTemplate: existingWorkoutTemplate)
        } catch {
            XCTFail("Failed to delete the workout template: \(error)")
        }
        
        // Then
        let allWorkoutTemplates = inTest.getAllWorkoutTemplates()
        XCTAssertEqual(allWorkoutTemplates.count, 0, "Should have no workout templates after deletion")
    }
    
    func testGetAllWorkoutTemplates() {
        // Given
        let workoutType1 = "Strength"
        let workoutType2 = "Cardio"
        
        inTest.createWorkoutTemplate(workoutType1)
        inTest.createWorkoutTemplate(workoutType2)
        
        // When
        let allWorkoutTemplates = inTest.getAllWorkoutTemplates()
        
        // Then
        XCTAssertEqual(allWorkoutTemplates.count, 2, "Should retrieve two workout templates")
    }
    
    func testGetWorkoutTemplateById() {
        // Given
        let workoutType = "Strength"
        inTest.createWorkoutTemplate(workoutType)
        
        guard let existingWorkoutTemplate = inTest.getAllWorkoutTemplates().first else {
            XCTFail("There should be an existing workout template")
            return
        }
        
        // When
        let retrievedWorkoutTemplate = inTest.getWorkoutTemplateById(id: existingWorkoutTemplate.objectID)
        
        // Then
        XCTAssertNotNil(retrievedWorkoutTemplate, "Should retrieve a workout template by its ID")
        XCTAssertEqual(retrievedWorkoutTemplate?.type, workoutType, "The retrieved workout template's type should match the original type")
    }
}

