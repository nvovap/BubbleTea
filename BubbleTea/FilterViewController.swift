//
//  FilterViewController.swift
//  BubbleTea
//
//  Created by Vladimir Nevinniy on 11/16/16.
//  Copyright © 2016 Vladimir Nevinniy. All rights reserved.
//

import UIKit
import CoreData

protocol FilterViewControllerDelegate: class {
    func filterViewController(filter: FilterViewController, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?)
}


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
    
    
    weak var delegate: FilterViewControllerDelegate?
    var selectedSortDescriptor: NSSortDescriptor?
    var selectedPredicate: NSPredicate?
    
    
    
    
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
    
    func popularDealsCountLabel() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Venue")
        
        
        fetchRequest.resultType = .dictionaryResultType
        
        //--------------SUMMA specialCount ----------------------
        let sumExpressionDesc = NSExpressionDescription()
        sumExpressionDesc.name = "sumDeals"
        sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "specialCount")])
        sumExpressionDesc.expressionResultType = .integer32AttributeType
        //-------------------------------------------------------
        
        
        
        fetchRequest.propertiesToFetch = [sumExpressionDesc]
        
        do{
            let results = try coreDataStack.context.fetch(fetchRequest) as! [NSDictionary]
            
            let resultDict = results.first!
            let numDeals = resultDict["sumDeals"]
            
            numDealsLabel.text = "\(numDeals!) total deals"
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        populateCheapVenueCountLabel()
        populateModerateVenueCountLabel()
        populateExpensiveVenueCountLabel()
        
        popularDealsCountLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        delegate?.filterViewController(filter: self, didSelectPredicate: selectedPredicate, sortDescriptor: selectedSortDescriptor)
        
        dismiss(animated: true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        switch cell {
        case cheapVenueCell:
            selectedPredicate = cheapVenuePredicate
        case moderateVenueCell:
            selectedPredicate = moderateVenuePredicate
        case expensiveVenueCell:
            selectedPredicate = expensiveVenuePredicate
        default:
            print("default case")
        }
        
        cell.accessoryType = .checkmark
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
