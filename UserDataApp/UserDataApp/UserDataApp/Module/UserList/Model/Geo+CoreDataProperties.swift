//
//  Geo+CoreDataProperties.swift
//  UserDataApp
//
//  Created by Datt Patel on 11/02/22.
//
//

import Foundation
import CoreData


extension Geo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Geo> {
        return NSFetchRequest<Geo>(entityName: Self.entityName)
    }

    @NSManaged public var lat: String?
    @NSManaged public var lng: String?
    @NSManaged public var address: Address?
    
    
}

extension Geo : Identifiable {

}
