//
//  ViewController.swift
//  BubbleTea
//
//  Created by Vladimir Nevinniy on 11/16/16.
//  Copyright © 2016 Vladimir Nevinniy. All rights reserved.
//

import UIKit
import CoreData

let filterViewControllerSegueIdentifier = "toFilterViewController"
let venueCellIdentifier = "VenueCell"


class ViewController: UITableViewController {
    
   // var asyncFetchRequest: NSAsynchronousFetchRequest<Venue>!
    
    var coreDataStack: CoreDataStack!

    var fetchRequest: NSFetchRequest<Venue>!
    
  //  var venues: [NSAsynchronousFetchResult<Venue>]!
    
    var venues: [Venue]!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

//        let model = coreDataStack.context.persistentStoreCoordinator!.managedObjectModel
//        
//        fetchRequest = model.fetchRequestTemplate(forName: "FetchRequest") as! NSFetchRequest<Venue>
        
        fetchRequest = NSFetchRequest(entityName: "Venue")
        
//        asyncFetchRequest = NSAsynchronousFetchRequest<Venue>(fetchRequest: fetchRequest){[unowned self] (result: NSAsynchronousFetchResult<Venue>) in
//            self.venues = result.finalResult
//            self.tableView.reloadData()
//        }
//        
//        
//        do {
//            try coreDataStack.context.fetch(asyncFetchRequest)
//        } catch let error {
//            print(error)
//        }
        
        
        
        
        fetchAndReload()
    }
    
   
    
    func fetchAndReload() {
        do {
            venues = try coreDataStack.context.fetch(fetchRequest) as [Venue]
        
            tableView.reloadData()
        } catch let error {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == filterViewControllerSegueIdentifier {
            let navigationController = segue.destination as! UINavigationController
            
            let filterViewController = navigationController.topViewController  as! FilterViewController
            
            filterViewController.delegate = self
            
            filterViewController.coreDataStack = coreDataStack
        }
    }

}


//MARK: FilterViewControllerDelegate

extension ViewController: FilterViewControllerDelegate {
    func filterViewController(filter: FilterViewController, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?) {
        
         fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = nil
        
        if let fetchPredicate = predicate {
            fetchRequest.predicate = fetchPredicate
        }
        
        if let sr = sortDescriptor {
            fetchRequest.sortDescriptors = [sr]
        }
        
        fetchAndReload()
    }
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: venueCellIdentifier)!
        
        let item = venues[indexPath.row]

        
        cell.textLabel!.text =  item.name
        cell.detailTextLabel!.text = item.priceInfo?.priceCategory
        
        return cell
    }
}

