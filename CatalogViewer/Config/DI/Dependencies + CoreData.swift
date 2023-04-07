//
//  Dependencies + CoreData.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 07/04/2023.
//

import Swinject
import CoreData
import DevTools
import DevToolsCoreData


let DI_CORE_DATA: (Container)->() = { diContainer in
    
    diContainer.register(NSPersistentContainer.self) { resolver in
        lazy var persistentContainer: NSPersistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
            */
            let container = NSPersistentContainer(name: "CatalogViewerDB")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                     
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
                
                diContainer.register(NSManagedObjectContext.self) { resolver in
                    return container.newBackgroundContext()
                }
                
            })
            return container
        }()
        
        return persistentContainer
    }

    
    diContainer.register(BasePersistedLayerInterface<Category>.self) { resolver in
        PersistentCoreDataStore<Category>(context: resolver.resolve(NSManagedObjectContext.self)!)
    }
}
