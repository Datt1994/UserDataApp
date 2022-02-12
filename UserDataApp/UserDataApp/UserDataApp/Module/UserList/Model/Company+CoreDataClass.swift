//
//  Company+CoreDataClass.swift
//  UserDataApp
//
//  Created by Datt Patel on 11/02/22.
//
//

import Foundation
import CoreData
import UserDataAppBase

@objc(Company)
public class Company: NSManagedObject, Decodable, CDHelperEntity {
    public static var entityName: String! { return "Company" }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case catchPhrase = "catchPhrase"
        case bs = "bs"
    }
    
    required convenience public init(from decoder: Decoder) throws {

        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: context) else { fatalError() }

        self.init(entity: entity, insertInto: context)

        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { return }
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.catchPhrase = try container.decodeIfPresent(String.self, forKey: .catchPhrase)
        self.bs = try container.decodeIfPresent(String.self, forKey: .bs)
        
    }
    
}
