//
//  Company+CoreDataProperties.swift
//  UserDataApp
//
//  Created by Datt Patel on 11/02/22.
//
//

import Foundation
import CoreData


extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: Self.entityName)
    }

    @NSManaged public var name: String?
    @NSManaged public var catchPhrase: String?
    @NSManaged public var bs: String?
    @NSManaged public var user: User?

}

extension Company : Identifiable {

}
