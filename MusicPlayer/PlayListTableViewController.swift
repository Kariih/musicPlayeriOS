
import UIKit
import CoreData

class PlayListTableViewController: UITableViewController,UITableViewDelegate, UITableViewDataSource  {
    
    var playList = [AnyObject]()
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool){
    }
    
    override func viewDidAppear(animated: Bool) {
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        JSONData().jsonGetRequest()
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "PlayListEntity")
        request.returnsObjectsAsFaults = false
        playList = context.executeFetchRequest(request, error: nil)!
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId: String = "cell"
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as UITableViewCell
        index = indexPath.row
        var data : NSManagedObject = playList[indexPath.row] as NSManagedObject
        cell.textLabel.text = data.valueForKeyPath("artist") as? String
        cell.detailTextLabel?.text = data.valueForKeyPath("title") as? String
        
        return cell
    }
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        
        if editingStyle == UITableViewCellEditingStyle.Delete{
            context.deleteObject(playList[indexPath.row] as NSManagedObject)
            playList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        var error: NSError? = nil
        if !context.save(&error){
            abort()
        }
        
    }
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if let seq = segue.destinationViewController as?SoundPlayerController {
            seq.songIndex = index
        }
        
    }
    
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}