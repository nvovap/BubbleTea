//
//  AppDelegate.swift
//  BubbleTea
//
//  Created by Vladimir Nevinniy on 11/16/16.
//  Copyright © 2016 Vladimir Nevinniy. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var coreDataStack = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        let navigationController = window!.rootViewController as! UINavigationController
        
        let viewController = navigationController.topViewController as! ViewController
        
        viewController.coreDataStack = coreDataStack

        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Venue")
        
        do {
            
            let results =
                try coreDataStack.context.count(for: fetchRequest)
            
            if (results == 0) {
                
                do {
                    let results =
                        try coreDataStack.context.fetch(fetchRequest) as! [Venue]
                    
                    for object in results {
                        let team = object as Venue
                        coreDataStack.context.delete(team)
                    }
                    
                    coreDataStack.saveContext()
                    importJSONSeedData()
                    
                } catch let error as NSError {
                    print("Error fetching: \(error.localizedDescription)")
                }
            }

            
        } catch let error {
            print(error)
        }
        
        
        return true
    }
    
    
    
    func importJSONSeedData() {
        let jsonURL = Bundle.main.url(forResource: "seed", withExtension: "json")
        let jsonData = try? Data(contentsOf: jsonURL!)
        
        let venueEntity = NSEntityDescription.entity(forEntityName: "Venue", in: coreDataStack.context)
        let locationEntity = NSEntityDescription.entity(forEntityName: "Location", in: coreDataStack.context)
        let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in: coreDataStack.context)
        let priceEntity = NSEntityDescription.entity(forEntityName: "PriceInfo", in: coreDataStack.context)
        let statsEntity = NSEntityDescription.entity(forEntityName: "Stats", in: coreDataStack.context)
        
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! Dictionary<String, Any>
            
            
            let jsonDict2 = jsonDict["response"]  as! Dictionary<String, Any>
          
            let jsonArray = jsonDict2["venues"] as! Array<Dictionary<String, Any>>
                
            
            
            
            for jsonDictionary in jsonArray {
                
                let venueName = jsonDictionary["name"] as? String
                let venuePhone = (jsonDictionary as AnyObject).value(forKeyPath: "contact.phone") as? String
                let specialCount = (jsonDictionary as AnyObject).value(forKeyPath: "specials.count")
                
                let locationDict = jsonDictionary["location"] as! NSDictionary
                let priceDict = jsonDictionary["price"] as! NSDictionary
                let statsDict = jsonDictionary["stats"] as! NSDictionary
                
                let location = Location(entity: locationEntity!, insertInto: coreDataStack.context)
                location.address = locationDict["address"] as? String
                location.city = locationDict["city"] as? String
                location.state = locationDict["state"] as? String
                location.zipcode = locationDict["postalCode"] as? String
                
                
                if let distance = locationDict["distance"] as? Float {
                    location.distance = distance
                }
                
               
                
                let category = Category(entity: categoryEntity!, insertInto: coreDataStack.context)
                
                let priceInfo = PriceInfo(entity: priceEntity!, insertInto: coreDataStack.context)
                priceInfo.priceCategory = priceDict["currency"] as? String
                
                let stats = Stats(entity: statsEntity!, insertInto: coreDataStack.context)
                
                
                if let checkinsCount = statsDict["checkinsCount"] as? Int32 {
                     stats.checkinsCount = checkinsCount
                }
  
                
                
                if let usersCount = statsDict["userCount"] as? Int32 {
                    stats.usersCount = usersCount
                }
                
                
                if let tipCount = statsDict["tipCount"] as? Int32 {
                    stats.tipCount =  tipCount
                }
                
                let venue = Venue(entity: venueEntity!, insertInto: coreDataStack.context)
                venue.name = venueName
                venue.phone = venuePhone
                
                
                if let specialCount = specialCount as? Int32 {
                    venue.specialCount = specialCount
                }
                
                
                
                
                venue.location = location
                venue.category = category
                venue.priceInfo = priceInfo
                venue.stats = stats
            }
            
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Deserialization error: \(error.localizedDescription)")
        }
    }
    


    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreDataStack.saveContext()
    }

    // MARK: - Core Data stack


}

