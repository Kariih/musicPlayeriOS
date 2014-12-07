import UIKit
import CoreData
import AVFoundation

class PlayListTableViewController: UITableViewController,UITableViewDelegate, UITableViewDataSource{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool){
        if music.songsPlaying.count > 0 {
            startPlaying()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        JSONData().jsonGetRequest()
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "PlayListEntity")
        request.returnsObjectsAsFaults = false
        music.playList = context.executeFetchRequest(request, error: nil)!
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return music.playList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId: String = "cell"
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as UITableViewCell
        var data : NSManagedObject = music.playList[indexPath.row] as NSManagedObject
        var urlString = data.valueForKeyPath("picture") as? String
        let url = NSURL(string: urlString!)
        var err: NSError?
        var imageData :NSData = NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
        cell.imageView.image = UIImage(data: imageData)
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
            context.deleteObject(music.playList[indexPath.row] as NSManagedObject)
            music.playList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        var error: NSError? = nil
        if !context.save(&error){
            abort()
        }
        
    }
    func startPlaying(){
        music.songsPlaying.removeAll()
        var index = music.currentSongInList
        for index in index...music.playList.count-1{
            var data : NSManagedObject = music.playList[index] as NSManagedObject
            var songUrl = data.valueForKeyPath("preview") as? String
            let url = NSURL(string: songUrl!)
            println("index: \(index) og listetørrelse er: \(music.playList.count)")
            music.songsPlaying.append(AVPlayerItem(URL: url!))
        }
        music.player = AVQueuePlayer(items: music.songsPlaying)
        println("is in player")
        music.player.play()
        println("is in player after play")
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        music.currentSongInList = indexPath.row
        println("indexPath: \(indexPath.row)")
        println("In music file: \(music.currentSongInList)")
        startPlaying()
     
    }
    @IBAction func playPrev(sender: AnyObject) {
        music.removeOne()
        startPlaying()
    }
    
    @IBAction func playNext(sender: AnyObject) {
        music.addOne()
        startPlaying()
    }
    @IBAction func pause(sender: AnyObject) {
        music.player.pause()
    }
    @IBAction func play(sender: AnyObject) {
        music.player.play()
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    
}