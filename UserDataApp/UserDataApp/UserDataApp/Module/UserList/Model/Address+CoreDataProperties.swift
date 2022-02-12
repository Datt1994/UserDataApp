//
//  Address+CoreDataProperties.swift
//  UserDataApp
//
//  Created by Datt Patel on 11/02/22.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: Self.entityName)
    }

    @NSManaged public var street: String?
    @NSManaged public var suite: String?
    @NSManaged public var city: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var geo: Geo?
    @NSManaged public var user: User?

}

extension Address : Identifiable {

}
