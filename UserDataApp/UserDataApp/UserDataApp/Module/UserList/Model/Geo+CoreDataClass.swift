//
//  Geo+CoreDataClass.swift
//  UserDataApp
//
//  Created by Datt Patel on 11/02/22.
//
//

import Foundation
import CoreData
import UserDataAppBase

@objc(Geo)
public class Geo: NSManagedObject, Decodable, CDHelperEntity {
    public static var entityName: String! { return "Geo" }

    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
    
    required convenience public init(from decoder: Decoder) throws {

        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: context) else { fatalError() }

        self.init(entity: entity, insertInto: context)

        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { return }
        self.lat = try container.decodeIfPresent(String.self, forKey: .lat)
        self.lng = try container.decodeIfPresent(String.self, forKey: .lng)
        
    }
    
    
}
