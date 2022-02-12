//
//  User+CoreDataClass.swift
//  UserDataApp
//
//  Created by Datt Patel on 11/02/22.
//
//

import Foundation
import CoreData
import UserDataAppBase
import RxDataSources

@objc(User)
public class User: NSManagedObject, Decodable, CDHelperEntity, IdentifiableType {
    
    public static var entityName: String! { return "User" }
    
    public typealias Identity = String
    public var identity: String {
        return id == 0 ? UUID().uuidString : String(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case username = "username"
        case email = "email"
        case phone = "phone"
        case website = "website"
        case address = "address"
        case company = "company"
        case imagepath = "imagepath"
    }
    
    required convenience public init(from decoder: Decoder) throws {

        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: context) else { fatalError() }

        self.init(entity: entity, insertInto: context)

        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { return }
        self.id = try container.decodeIfPresent(Int64.self, forKey: .id) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.username = try container.decodeIfPresent(String.self, forKey: .username)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.website = try container.decodeIfPresent(String.self, forKey: .website)
        self.imagepath = try container.decodeIfPresent(String.self, forKey: .imagepath)
        self.address = try container.decodeIfPresent(Address.self, forKey: .address)
        self.company = try container.decodeIfPresent(Company.self, forKey: .company)
    }
}



