//
//  UserListViewModel.swift
//  UserDataApp
//
//  Created by Datt Patel on 12/02/22.
//

import UIKit
import RxRelay
import UserDataAppBase

class UserListViewModel {
    var users: BehaviorRelay<[BehaviorRelay<User?>]> = .init(value: [])
}

//MARK: Public methods
extension UserListViewModel {
    
    func getUserApi(_ loaderInView: UIView, completion: @escaping (_ error: String?) -> ()) {
        
        guard !UserDefaults.standard.bool(forKey: UserDefaultKeys.isUserDataLoaded) else {
            users.accept(User.findAll().map { .init(value: $0) })
            return
        }

        ApiCall().get(apiUrl: WebServiceURL.users, model: [User].self, loaderInView: loaderInView) { [weak self] result in
            switch result {

            case .success(let response):
                print(response.count)
                self?.users.accept(User.findAll().map { .init(value: $0) })
                UserDefaults.standard.set(true, forKey: UserDefaultKeys.isUserDataLoaded)
                completion(nil)
            case .error(let error):
                completion(error?.localizedDescription)
            }
        }
    }
    
    func resetApp(_ loaderInView: UIView) {
        let users = User.findAll()
        
        users.forEach { user in
            // remove stored images
            if let imagepath = user.imagepath {
                do {
                    let targetURL = URL(fileURLWithPath:imagepath)
                    if FileManager.default.fileExists(atPath: targetURL.path) {
                        try FileManager.default.removeItem(at: targetURL)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            // remove from coredata
            user.destroy()
        }
        self.users.accept([])
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.isUserDataLoaded)
        
        getUserApi(loaderInView) { error in
            if let error = error {
                UIApplication.topViewController()?.view.makeToast(error)
                return
            }
        }
    }
    
}

//MARK: Private methods
private extension UserListViewModel {
    
 
    
}

