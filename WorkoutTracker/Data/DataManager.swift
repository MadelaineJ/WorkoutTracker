//
//  DataManager.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import Foundation
import CoreData
import SwiftUI

class DataManager {
    
    static let shared = DataManager()
    
    var persistentContainer: NSPersistentCloudKitContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    enum StoreType {
        case actual, inMemory
    }
    
    init(storeType: StoreType = .actual) {
        persistentContainer = NSPersistentCloudKitContainer(name: "WorkoutTracker")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if storeType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            persistentContainer.persistentStoreDescriptions = [description]
        }
        
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    static var preview: DataManager {
        let manager = DataManager(storeType: .inMemory)
        return manager
    }
}


