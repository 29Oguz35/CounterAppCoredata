import UIKit
import CoreData

var countList = [Count]()
class CountTableView: UITableViewController {
    
    var firstLoad = true
    
    func nonDeletedCounts() -> [Count] {
        var nonDeletedCountList = [Count]()
        for count in countList {
            
            if(count.deletedDate == nil) {
                nonDeletedCountList.append(count)
                
            }
            
        }
        return nonDeletedCountList
        
    }
    
    override func viewDidLoad() {
        if (firstLoad) {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Count")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    
                    let count = result as! Count
                    countList.append(count)
                }
            } catch  {
                print("Fetch Failed")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let countCell = tableView.dequeueReusableCell(withIdentifier: "countCellID", for: indexPath) as! CountCell
        
        let thisCount: Count!
        thisCount = nonDeletedCounts()[indexPath.row]
        
        countCell.countLB.text = thisCount.count
        countCell.objectLabel.text = thisCount.object
        
        return countCell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedCounts().count
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editCount", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editCount" ) {
            
            let indexPath = tableView.indexPathForSelectedRow!
            
            let countDetail = segue.destination as? CountDetailVC
            
            let selectedCount: Count!
            selectedCount = nonDeletedCounts()[indexPath.row]
            countDetail!.selectedCount = selectedCount
            
            tableView.deselectRow(at: indexPath, animated: true)
    }
    }
}
