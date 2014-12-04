import UIKit
import CoreData

class Model: NSManagedObject {
    
    @NSManaged var item : String
    @NSManaged var quantity : String
    @NSManaged var info : String

    
   
}
