//
//  ViewController.swift
//  BubbleTea
//
//  Created by Vladimir Nevinniy on 11/16/16.
//  Copyright © 2016 Vladimir Nevinniy. All rights reserved.
//

import UIKit

let filterViewControllerSegueIdentifier = "toFilterViewController"
let venueCellIdentifier = "VenueCell"

class ViewController: UITableViewController {
    
    var coreDataStack: CoreDataStack!

    var fetchRequest: NSFetchRequest? 
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        fetchRequest = coreDataStack.context.persistentStoreCoordinator?.managedObjectModel.fetchRequestTemplatesByName("  ")
        fetchRequest = Venue.fetchRequest() as Array<Venue>
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == filterViewControllerSegueIdentifier {
            
        }
    }
    
  

}


extension ViewController {
    

    
   
    
    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: venueCellIdentifier)!
        cell.textLabel!.text = "Bubble Tea Venue"
        cell.detailTextLabel!.text = "Price Info"
        
        return cell
    }
}

