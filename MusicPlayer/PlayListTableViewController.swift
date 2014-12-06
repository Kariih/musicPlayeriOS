import UIKit
import CoreData
import AVFoundation

class PlayListTableViewController: UITableViewController,UITableViewDelegate, UITableViewDataSource{
    
    var playList = [AnyObject]()
    var player:AVQueuePlayer!
    var songsPlaying = [AnyObject]()
    
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
    func startPlaying(index: Int){
        songsPlaying.removeAll()
        for index in index...playList.count-1{
            var data : NSManagedObject = playList[index] as NSManagedObject
            var songUrl = data.valueForKeyPath("preview") as? String
            let url = NSURL(string: songUrl!)
            music.oneSong.title = data.valueForKeyPath("title") as String
            music.oneSong.artist = data.valueForKeyPath("artist") as String
            println("index: \(index) og listetørrelse er: \(playList.count)")
            songsPlaying.append(AVPlayerItem(URL: url!))
        }
        music.currentSongInList = index
        player = AVQueuePlayer(items: songsPlaying)
        println("is in player")
        player.play()
        println("is in player after play")
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        music.currentSongInList = indexPath.row
        startPlaying(indexPath.row)
     
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