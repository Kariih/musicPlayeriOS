import UIKit
import CoreData

class ItemViewController: UIViewController {

    @IBOutlet weak var txtItem: UITextField!
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var txtInfo: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func savePressed(sender: AnyObject) {
        
        let appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context : NSManagedObjectContext = appDel.managedObjectContext!
       // let en = NSEntityDescription.entityForName("List", inManagedObjectContext: context)
        var newItem = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: context) as NSManagedObject

        
        newItem.setValue(txtItem.text, forKey: "item")
        newItem.setValue(txtQuantity.text, forKey: "quantity")
        newItem.setValue(txtInfo.text, forKey: "info")
        
        context.save(nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
