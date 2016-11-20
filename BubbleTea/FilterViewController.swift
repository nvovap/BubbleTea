//
//  FilterViewController.swift
//  BubbleTea
//
//  Created by Vladimir Nevinniy on 11/16/16.
//  Copyright © 2016 Vladimir Nevinniy. All rights reserved.
//

import UIKit
import CoreData

class FilterViewController: UITableViewController {

    
    
    @IBOutlet weak var firstPriceCategoryLabel: UILabel!
    @IBOutlet weak var secondPriceCategoryLabel: UILabel!
    @IBOutlet weak var thirdPriceCategoryLabel: UILabel!
    @IBOutlet weak var numDealsLabel: UILabel!
    
    
    
    @IBOutlet weak var cheapVenueCell: UITableViewCell!
    @IBOutlet weak var moderateVenueCell: UITableViewCell!
    @IBOutlet weak var expensiveVenueCell: UITableViewCell!
    
    
    @IBOutlet weak var offeringDealCell: UITableViewCell!
    @IBOutlet weak var walkingDistanceCell: UITableViewCell!
    @IBOutlet weak var userTipsCell: UITableViewCell!
    
    
    @IBOutlet weak var nameAZSortCell: UITableViewCell!
    @IBOutlet weak var nameZASortCell: UITableViewCell!
    @IBOutlet weak var distanceSortCell: UITableViewCell!
    @IBOutlet weak var priceSortCell: UITableViewCell!
    
    
    
    var coreDataStack: CoreDataStack!
    
    
    lazy var cheapVenuePredicate: NSPredicate = {
        var predicate = NSPredicate(format: "priceInfo.priceCategory == %@", "$")
        
        return predicate
    }()
    
    lazy var moderateVenuePredicate: NSPredicate = {
        var predicate = NSPredicate(format: "priceInfo.priceCategory == %@", "$$")
        
        return predicate
    }()
    
    lazy var expensiveVenuePredicate: NSPredicate = {
        var predicate = NSPredicate(format: "priceInfo.priceCategory == %@", "$$$")
        
        return predicate
    }()
    
    func populateCheapVenueCountLabel() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Venue")
        fetchRequest.resultType = .countResultType
        fetchRequest.predicate = cheapVenuePredicate
        
        do {
            let results = try coreDataStack.context.fetch(fetchRequest) as! [Int]
            
            let count = results.first!
        
            
            firstPriceCategoryLabel.text = "\(count) bubble tea places"
        }catch let error {
            print(error)
        }
        
    }
    
    func populateModerateVenueCountLabel() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Venue")
        fetchRequest.resultType = .countResultType
        fetchRequest.predicate = moderateVenuePredicate
        
        do {
            let results = try coreDataStack.context.fetch(fetchRequest) as! [Int]
            
            let count = results.first!
            
            
            secondPriceCategoryLabel.text = "\(count) bubble tea places"
        }catch let error {
            print(error)
        }
        
    }
    
    func populateExpensiveVenueCountLabel() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Venue")
      //  fetchRequest.resultType = .countResultType
        fetchRequest.predicate = expensiveVenuePredicate
        
        do {
            let count = try coreDataStack.context.count(for: fetchRequest)
            
            
            if count != NSNotFound {
                thirdPriceCategoryLabel.text = "\(count) bubble tea places"
            } else {
                print("Could not fetch")
            }
            
        }catch let error {
            print(error)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        populateCheapVenueCountLabel()
        populateModerateVenueCountLabel()
        populateExpensiveVenueCountLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
