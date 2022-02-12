//
//  AddEditUserViewModel.swift
//  UserDataApp
//
//  Created by Datt Patel on 12/02/22.
//

import UIKit
import RxRelay
import CoreLocation
import UserDataAppBase
import PhoneNumberKit

enum ValidationState {
    case valid
    case invalid(String)
}

class AddEditUserViewModel {
    var user: BehaviorRelay<User?> = .init(value: nil)
    
    var imagepath: BehaviorRelay<String> = .init(value: "")
    var name: BehaviorRelay<String> = .init(value: "")
    var username: BehaviorRelay<String> = .init(value: "")
    var email: BehaviorRelay<String> = .init(value: "")
    var phone: BehaviorRelay<String> = .init(value: "")
    var website: BehaviorRelay<String> = .init(value: "")
    
    var suite: BehaviorRelay<String> = .init(value: "")
    var street: BehaviorRelay<String> = .init(value: "")
    var city: BehaviorRelay<String> = .init(value: "")
    var zipcode: BehaviorRelay<String> = .init(value: "")
    var lat: BehaviorRelay<String> = .init(value: "")
    var lng: BehaviorRelay<String> = .init(value: "")
    
    var companyName: BehaviorRelay<String> = .init(value: "")
    var catchPhrase: BehaviorRelay<String> = .init(value: "")
    var bs: BehaviorRelay<String> = .init(value: "")
}

//MARK: Public methods
extension AddEditUserViewModel {
    func saveData() -> ValidationState {
        let valid = validate()
        
        switch valid {
            
        case .valid:
            var user = user.value
            if user == nil { // Add new User
                user = User.new()
                user?.id = Int64(Date().nanosecond)
                user?.address = Address.new()
                user?.company = Company.new()
                user?.address?.geo = Geo.new()
            }
            user?.imagepath = imagepath.value
            user?.name = name.value
            user?.username = username.value
            user?.email = email.value
            user?.phone = phone.value
            user?.website = website.value
            
            user?.address?.suite = suite.value
            user?.address?.street = street.value
            user?.address?.city = city.value
            user?.address?.zipcode = zipcode.value
            user?.address?.geo?.lat = lat.value
            user?.address?.geo?.lng = lng.value
            
            user?.company?.name = companyName.value
            user?.company?.catchPhrase = catchPhrase.value
            user?.company?.bs = bs.value
            
            user?.save()
            self.user.accept(user)
        case .invalid(_):
            break
        }

        return valid
    }
    
    func getPlacemarkFromLatLon(_ coordinate: CLLocation, completion: @escaping ((CLPlacemark) -> Void)) {
        CLGeocoder().reverseGeocodeLocation(coordinate, completionHandler: {
            (placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            if let placemark = placemarks?.first {
                completion(placemark)
            }
        })
        
    }
}

//MARK: Private methods
private extension AddEditUserViewModel {
    func validate() -> ValidationState {
        if name.value.trimmed.count == 0 {
            return .invalid(AlertMessage.name)
        } else if username.value.trimmed.count == 0 {
            return .invalid(AlertMessage.username)
        } else if email.value.trimmed.count == 0 {
            return .invalid(AlertMessage.email)
        } else if !email.value.isEmail {
            return .invalid(AlertMessage.validEmail)
        } else if phone.value.trimmed.count == 0 {
            return .invalid(AlertMessage.phone)
        }  else if website.value.trimmed.count == 0 {
            return .invalid(AlertMessage.website)
        } else if lat.value.count == 0 {
            return .invalid(AlertMessage.pickLocation)
        } else if suite.value.trimmed.count == 0 {
            return .invalid(AlertMessage.suite)
        } else if street.value.trimmed.count == 0 {
            return .invalid(AlertMessage.street)
        } else if city.value.trimmed.count == 0 {
            return .invalid(AlertMessage.city)
        } else if zipcode.value.trimmed.count == 0 {
            return .invalid(AlertMessage.zipcode)
        } else if companyName.value.trimmed.count == 0 {
            return .invalid(AlertMessage.companyName)
        } else if catchPhrase.value.trimmed.count == 0 {
            return .invalid(AlertMessage.catchPhrase)
        } else if bs.value.trimmed.count == 0 {
            return .invalid(AlertMessage.bs)
        }
        return .valid
    }
}


