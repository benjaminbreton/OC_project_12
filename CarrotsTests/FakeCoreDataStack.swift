//
//  FakeCoreDataStack.swift
//  CarrotsTests
//
//  Created by Benjamin Breton on 19/03/2021.
//

import Foundation
import Carrots
import CoreData
class FakeCoreDataStack: CoreDataStack {
    override init() {
        super.init()
        // create new description with an InMemoryStoreType
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        // create new container
        let container = NSPersistentContainer(name: "Carrots")
        // set new description to new container's persistentStoreDescriptions
        container.persistentStoreDescriptions = [persistentStoreDescription]
        // load persistent stores
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        // set new container to self.persistentContainer
        self.persistentContainer = container
    }
}
