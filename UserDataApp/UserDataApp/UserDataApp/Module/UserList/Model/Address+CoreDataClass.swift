//
//  Address+CoreDataClass.swift
//  UserDataApp
//
//  Created by Datt Patel on 11/02/22.
//
//

import Foundation
import CoreData
import UserDataAppBase

@objc(Address)
public class Address: NSManagedObject, Decodable, CDHelperEntity {
    public static var entityName: String! { return "Address" }
    
    enum CodingKeys: String, CodingKey {
        case street = "street"
        case suite = "suite"
        case city = "city"
        case zipcode = "zipcode"
        case geo = "geo"
    }
    
    required convenience public init(from decoder: Decoder) throws {

        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: context) else { fatalError() }

        self.init(entity: entity, insertInto: context)

        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { return }
        
        self.street = try container.decodeIfPresent(String.self, forKey: .street)
        self.suite = try container.decodeIfPresent(String.self, forKey: .suite)
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.zipcode = try container.decodeIfPresent(String.self, forKey: .zipcode)
        self.geo = try container.decodeIfPresent(Geo.self, forKey: .geo)
    
    }
    
}
