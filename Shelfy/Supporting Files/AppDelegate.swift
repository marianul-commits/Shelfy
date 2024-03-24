//
//  AppDelegate.swift
//  Shelfy
//
//  Created by Marian Nasturica on 04.06.2023.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        


//        let userLoginStatus = UserDefaults.standard.bool(forKey: "isLoggedIn")
//        
//        if userLoginStatus{
//            window?.rootViewController = HomeController()
//            window?.makeKeyAndVisible()
//        } else {
//            window?.rootViewController = LoginView()
//            window?.makeKeyAndVisible()
//        }
        
        
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<BookCategory> = BookCategory.fetchRequest()
        let count = try? context.count(for: request)
        
        if count == 0 {
            createDefaultBookCategory()
        }
        
        setBookPagesZero()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func createDefaultBookCategory() {
        // Assuming you have a managed object subclass named "Item"
        let fetchRequest: NSFetchRequest<BookCategory> = BookCategory.fetchRequest()
        
        do {
            let items = try persistentContainer.viewContext.fetch(fetchRequest)
            if items.isEmpty {
                // The container is empty, create a new item
                let newItem = BookCategory(context: persistentContainer.viewContext)
                // Set properties of newItem here
                newItem.name = "Read Books"
                // Save the context
                try persistentContainer.viewContext.save()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func setBookPagesZero() {
        let fetchRequest: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookPages == nil || bookPages == %@", "")
        
        do {
            let context = persistentContainer.viewContext
            let books = try context.fetch(fetchRequest)
            
            for book in books {
                if book.bookPages == nil || book.bookPages!.isEmpty {
                    book.bookPages = "0"
                }
            }
            
            try context.save()
            print("Book pages reset to zero for \(books.count) book(s).")
        } catch {
            print("Failed to reset book pages to zero: \(error)")
        }
    }
    
    
    
    
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


