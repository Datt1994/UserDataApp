//
//  User+CoreDataProperties.swift
//  UserDataApp
//
//  Created by Datt Patel on 11/02/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: Self.entityName)
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var website: String?
    @NSManaged public var imagepath: String?
    @NSManaged public var address: Address?
    @NSManaged public var company: Company?

}

extension User : Identifiable {

}

extension CodingUserInfoKey {
   static let context = CodingUserInfoKey(rawValue: "context")
}
