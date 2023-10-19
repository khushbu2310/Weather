//
//  PersistentStorage.swift
//  Weather
//
//  Created by Khushbuben Patel on 17/10/23.
//

import Foundation
import CoreData

protocol PersistentStorageProtocol {
    var persistentContainer: NSPersistentContainer { get }
    var context: NSManagedObjectContext { get }
    func saveContext()
    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]?
}

class PersistentStorage: PersistentStorageProtocol {
    
    private init(){}
    
    static let shared = PersistentStorage()

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]? {
        do {
            guard let result = try PersistentStorage.shared.context.fetch(managedObject.fetchRequest()) as? [T] else { return nil }
            return result
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
    
}
