
import CoreData

@objc(Count)
class Count: NSManagedObject {
    
    @NSManaged var id: NSNumber!
    @NSManaged var count: String!
    @NSManaged var object: String!
    @NSManaged var deletedDate: Date?
}
