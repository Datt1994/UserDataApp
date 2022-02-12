//
//  AppDelegate.swift
//  UserDataApp
//
//  Created by Datt Patel on 10/02/22.
//

import UIKit
import CoreData
import UserDataAppBase
import IQKeyboardManagerSwift
import PhoneNumberKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CDHelper.initializeWithMainContext(self.persistentContainer.viewContext)
        
        IQKeyboardManager.shared.enable = true
        
        PhoneNumberKit.CountryCodePicker.commonCountryCodes = ["US", "CA", "IN", "AU", "GB", "DE", "MX"]
        PhoneNumberKit.CountryCodePicker.forceModalPresentation = true
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: Font.poppinsTextBold.withSize(20)]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.font: Font.poppinsTextBold.withSize(35)]
        
        window = UIWindow()
        let nav = SwipeNavigationController(rootViewController: UserListVC())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "UserDataApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

