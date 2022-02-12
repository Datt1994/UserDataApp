//
//  UserSection.swift
//  UserDataApp
//
//  Created by Datt Patel on 12/02/22.
//

import Foundation
import RxDataSources
import RxRelay

struct UserSection {
    var header: String
    var users: [BehaviorRelay<User?>]
}

extension UserSection: AnimatableSectionModelType {
    typealias Item = BehaviorRelay<User?>
    typealias Identity = String

    var identity: String {
        return "UserSection"
    }

    var items: [BehaviorRelay<User?>] {
        return users
    }
    
    init(original: UserSection, items: [BehaviorRelay<User?>]) {
        self = original
        self.users = items
    }
}

extension BehaviorRelay: IdentifiableType, Equatable where Element == Optional<User> {
    
    public typealias Identity = String
    public var identity: String {
        return value?.identity ?? UUID().uuidString
    }
    
    public static func == (lhs: BehaviorRelay<Element>, rhs: BehaviorRelay<Element>) -> Bool {
        lhs.value?.id == rhs.value?.id
    }
}
