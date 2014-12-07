import UIKit
import CoreData

class SearchSongTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: Selector("refresh:"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl!)
        

    }
    override func viewWillAppear(animated: Bool){
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        println("is in searchView")
        println(music.songs.count)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return music.songs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        let cellId: String = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell
        if music.songs.count > 0 {
        cell.textLabel.text = music.songs[indexPath.row].title
        cell.detailTextLabel?.text = music.songs[indexPath.row].artist
        var urlString = music.songs[indexPath.row].picture
        let url = NSURL(string: urlString)
        var err: NSError?
        var imageData :NSData = NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
        cell.imageView.image = UIImage(data: imageData)
        }
        return cell
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar!){
    
        var searchTxt = searchBar.text
        jsonRequest(searchTxt)
        tableView.reloadData()
        
    }
    //clikable list
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        var newItem = NSEntityDescription.insertNewObjectForEntityForName("PlayListEntity", inManagedObjectContext: context) as NSManagedObject
        
        newItem.setValue(music.songs[indexPath.row].title, forKey: "title")
        println(music.songs[indexPath.row].title)
        newItem.setValue(music.songs[indexPath.row].artist, forKey: "artist")
        println(music.songs[indexPath.row].artist)
        newItem.setValue(music.songs[indexPath.row].sound, forKey: "preview")
        println(music.songs[indexPath.row].sound)
        newItem.setValue(music.songs[indexPath.row].picture, forKey: "picture")
        println(music.songs[indexPath.row].picture)

        context.save(nil)
        
        println("setDefaults")
        let defaults = NSUserDefaults()
        defaults.setObject("song is added", forKey: "songKey")
        defaults.synchronize()

     //   self.navigationController?.popToRootViewControllerAnimated(true)

        
        
    }
    func jsonRequest(search: String){
        
        var searchInput: String = "";
        var lineArray : [String] = search.componentsSeparatedByString(" ")
        var count: Int = 0
        
        for a in lineArray{
            searchInput += lineArray[count]
            if a != lineArray.last {
                searchInput+="+"
            }
            count++;
        }
        println("search for string \(searchInput)")
        
        
        let url = NSURL(string: "https://api.spotify.com/v1/search?q=" + searchInput + "&type=track")
        println(url)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data,options:nil,error: nil) {
                if let res = jsonResult as? NSDictionary {
                    var picture: String = ""
                    music.songs.removeAll()
                    let track = res["tracks"]! as NSDictionary
                    let tracks = track["items"] as NSArray
                    var finalPicture: String = ""
                    for t in tracks{
                        let title = t["name"] as NSString
                        let sound = t["preview_url"] as NSString
                        let artists = t["artists"] as NSArray
                        let artist = artists[0]["name"] as NSString
                        let album = t["album"] as NSDictionary
                        if let images = album["images"] as? NSArray{
                            if images.count > 1 {
                                let picture = images[1]["url"] as? NSString
                                    println("picture: \(picture)")
                                    finalPicture = picture!
                                    music.addSong(title, artist: artist, picture: finalPicture, sound: sound)

                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            if (self.refreshControl!.refreshing) {
                                self.refreshControl!.endRefreshing()
                            }
                            
                            self.tableView.reloadData()
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        })

                        
                    }
                    
                }
            }
        })
        task.resume()
    }

    
    
    //------------------------------------------------------

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
