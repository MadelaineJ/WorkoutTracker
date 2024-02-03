//
//  ExerciseTemplateViewModelTest.swift
//  WorkoutTrackerTests
//
//  Created by Madelaine Jones on 2024-01-05.
//

import XCTest
@testable import WorkoutTracker
import CoreData

class ExerciseTemplateViewModelTests: XCTestCase {

   var viewModel: ExerciseTemplateViewModel!
   var mockExerciseTemplateData: ExerciseTemplateData!
   var mockWorkoutTemplateData: WorkoutTemplateData!

   override func setUpWithError() throws {
       // Assuming you have a similar setup for your ExerciseTemplateData
       let testDataManager = DataManager(container: NSPersistentContainer.inMemoryContainer)
       mockExerciseTemplateData = ExerciseTemplateData(dataManager: testDataManager)
       mockWorkoutTemplateData = WorkoutTemplateData(dataManager: testDataManager)
       viewModel = ExerciseTemplateViewModel(controller: mockExerciseTemplateData)
   }

   override func tearDownWithError() throws {
       viewModel = nil
       mockExerciseTemplateData = nil
       mockWorkoutTemplateData = nil
   }

   func testCreateExerciseTemplate() {
       _ = viewModel.createExerciseTemplate(name: "Push-ups")
       viewModel.getAllExerciseTemplates()

       XCTAssertEqual(viewModel.exerciseTemplates.count, 1)
       XCTAssertEqual(viewModel.exerciseTemplates.first?.name, "Push-ups")
   }

   func testUpdateExerciseTemplate() {
       let exerciseTemplate = viewModel.createExerciseTemplate(name: "Push-ups")
       viewModel.getAllExerciseTemplates()
       viewModel.update(exerciseTemplate: ExerciseTemplateModel(exercise: exerciseTemplate), withNewInfo: "Modified Push-ups")
       viewModel.getAllExerciseTemplates()

       XCTAssertEqual(viewModel.exerciseTemplates.first?.name, "Modified Push-ups")
   }

   func testGetAllExerciseTemplates() {
       _ = viewModel.createExerciseTemplate(name: "Push-ups")
       _ = viewModel.createExerciseTemplate(name: "Sit-ups")
       viewModel.getAllExerciseTemplates()

       XCTAssertEqual(viewModel.exerciseTemplates.count, 2)
   }

   func testGetExerciseTemplatesByWorkoutTemplate() {
       _ = mockWorkoutTemplateData.createWorkoutTemplate("Strength")
       guard let workoutTemplate = mockWorkoutTemplateData.getAllWorkoutTemplates().first else {
           XCTFail("Failed to create workout template")
           return
       }

       _ = viewModel.createExerciseTemplate(name: "Push-ups")
       let exerciseTemplate = viewModel.createExerciseTemplate(name: "Pull-ups")
       mockExerciseTemplateData.addExerciseTemplate(workoutId: workoutTemplate.objectID, exerciseTemplate: exerciseTemplate)

       viewModel.getExerciseTemplates(workoutTemplate: WorkoutTemplateModel(workout: workoutTemplate))

       XCTAssertEqual(viewModel.exerciseTemplates.count, 1)
       XCTAssertEqual(viewModel.exerciseTemplates.first?.name, "Pull-ups")
   }

   func testAddExerciseTemplateToWorkoutTemplate() {
       _ = mockWorkoutTemplateData.createWorkoutTemplate("Strength")
       guard let workoutTemplate = mockWorkoutTemplateData.getAllWorkoutTemplates().first else {
           XCTFail("Failed to create workout template")
           return
       }

       viewModel.addExerciseTemplate(workoutTemplate: WorkoutTemplateModel(workout: workoutTemplate), name: "Sit-ups")

       viewModel.getExerciseTemplates(workoutTemplate: WorkoutTemplateModel(workout: workoutTemplate))

       XCTAssertEqual(viewModel.exerciseTemplates.count, 1)
       XCTAssertEqual(viewModel.exerciseTemplates.first?.name, "Sit-ups")
   }


   func testDeleteExerciseTemplate() {
       let exerciseTemplate = viewModel.createExerciseTemplate(name: "Push-ups")
       viewModel.getAllExerciseTemplates()
       
       viewModel.delete(ExerciseTemplateModel(exercise: exerciseTemplate))
       
       viewModel.getAllExerciseTemplates()
       XCTAssertEqual(viewModel.exerciseTemplates.count, 0)
   }
}

