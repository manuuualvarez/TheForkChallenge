//
//  PersistanceService.swift
//  TheForkChallenge
//
//  Created by Manuel Alvarez on 1/25/22.
//

import Foundation
import CoreData


enum CoreDataEntities: String {
    case favoriteRestaurantEntity = "FavoriteRestaurantEntity"
}


class PersistenceService {
    
    private init(){}
    static var context : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static func getFavoriteRestoCoreData()  -> [FavoriteRestaurantEntity]{
        let fetchRequest: NSFetchRequest<FavoriteRestaurantEntity> = FavoriteRestaurantEntity.fetchRequest()
        do {
            let localResto = try PersistenceService.context.fetch(fetchRequest)
            return localResto
            
        }catch{
            return []
        }
    }
    
    static func deleteItemInCoreData(uid: String) {
        let fetchRequest: NSFetchRequest<FavoriteRestaurantEntity> = FavoriteRestaurantEntity.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            let items = results.first{ $0.id == uid }
            guard let item = items else { return }
            context.delete(item)
        } catch let error {
            print("Failed delete item error :", error)
        }
    }
// MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "RestaurantModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
// MARK: - Core Data Saving support
    
    static func saveContext () {
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
