//
//  PostEntity+CoreDataProperties.swift
//  TheForkChallenge
//
//  Created by Manuel Alvarez on 1/25/22.
//

import Foundation
import CoreData

extension FavoriteRestaurantEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteRestaurantEntity> {
        return NSFetchRequest<FavoriteRestaurantEntity>(entityName: CoreDataEntities.favoriteRestaurantEntity.rawValue)
    }
    
    @NSManaged public var id: String

    
}
