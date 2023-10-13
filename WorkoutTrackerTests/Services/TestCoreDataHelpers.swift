//
//  TestCoreDataHelpers.swift
//  WorkoutTrackerTests
//
//  Created by Madelaine Jones on 2023-10-08.
//

import Foundation
import CoreData
@testable import WorkoutTracker


extension NSPersistentContainer {
    static var inMemoryContainer: NSPersistentContainer {
        let container = NSPersistentContainer(name: "WorkoutTracker")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            precondition(error == nil)
        }
        return container
    }
}


// Extensions for Dependency Injection
extension DataManager {
    convenience init(container: NSPersistentContainer) {
        self.init()
        self.persistentContainer = container
    }
}
