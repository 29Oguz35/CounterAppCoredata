//
//  ViewController.swift
//  CounterAppCoreData
//
//  Created by naruto kurama on 8.08.2021.
//

import UIKit
import CoreData

class CountDetailVC: UIViewController {
    @IBOutlet weak var objectTF: UITextField!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var selectedCount: Count? = nil
    
    var plus = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(selectedCount != nil) {
            objectTF.text = selectedCount?.object
            countLabel.text = selectedCount?.count
        }else {
             
            deleteButton.isHidden = true
        
        }
       
    }
    @IBAction func saveAction(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if (selectedCount == nil) {
            let entity = NSEntityDescription.entity(forEntityName: "Count", in: context)
            let newCount = Count(entity: entity!, insertInto: context)
            newCount.id = countList.count as NSNumber
            newCount.count = countLabel.text
            newCount.object = objectTF.text
            do {
                try context.save()
                countList.append(newCount)
                navigationController?.popViewController(animated: true)
            }
            catch {
                print("context save error")
            }
            
        }else {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Count")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    
                    let count = result as! Count
                    if(count == selectedCount) {
                        count.count = String(plus)
                        count.object = objectTF.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            } catch  {
                print("Fetch Failed")
            }
        }
            
        }
        
    @IBAction func plusButtonClicked(_ sender: Any) {
        plus += 1
        countLabel.text = String(plus)
        
    }
    @IBAction func DeletedCount(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Count")
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                
                let count = result as! Count
                if(count == selectedCount) {
                    
                    count.deletedDate = Date()
                    
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        } catch  {
            print("Fetch Failed")
        }
    }
    @IBAction func exitButtonClicked(_ sender: Any) {
        
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
    

}

