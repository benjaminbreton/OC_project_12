//
//  CoreDataStack.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/03/2021.
//

import Foundation
import CoreData
open class CoreDataStack {
    
    // MARK: - Properties
    
    /// PersistentContainer used to get and save datas.
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Carrots")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    /// ViewContext used to get and save datas.
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    lazy var entities = Entities(viewContext)
    
    // MARK: - Init
    
    /// Init used to set persistentContainer in a FakeCoreDataStack.
    public init() { }
    
    // MARK: - Save context
    
    /// Save context.
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

