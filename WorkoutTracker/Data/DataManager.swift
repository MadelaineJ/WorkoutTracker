//
//  DataManager.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import Foundation
import CoreData
import SwiftUI

import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    var persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    enum StoreType {
        case actual, inMemory
    }
    
    init(storeType: StoreType = .actual) {
        persistentContainer = NSPersistentContainer(name: "WorkoutTracker")
        
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


