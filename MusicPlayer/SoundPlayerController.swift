import UIKit
import AVFoundation
import CoreData

class SoundPlayerController: UIViewController{
    
    
    var player:AVPlayer!
    var songIndex: Int?
    var song = music.oneSong
    var songList = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "PlayListEntity")
        request.returnsObjectsAsFaults = false
        songList = context.executeFetchRequest(request, error: nil)!
        getSongFromDB(songIndex!)
        playSong()
        addDataToView()
    }
    override func viewDidAppear(animated: Bool) {
    }
    func getSongFromDB(index :Int){
        var data : NSManagedObject = songList[index] as NSManagedObject
        song.artist = data.valueForKeyPath("artist") as String
        song.title = data.valueForKeyPath("title") as String
        song.picture = data.valueForKeyPath("picture") as String
        song.sound = data.valueForKeyPath("preview") as String
    }
    @IBAction func findPrevSong(sender: AnyObject) {
        songIndex!-1
        getSongFromDB(songIndex!)
        playSong()
        println(songIndex)
    }
    @IBAction func pauseSong(sender: AnyObject) {
        player.pause()
    }
    @IBAction func playSong(sender: AnyObject) {
        player.play()
    }
    @IBAction func findNextSong(sender: AnyObject) {
        songIndex!+1
        getSongFromDB(songIndex!)
        playSong()
        println(songIndex)
    }
    func playSong(){
        let url = NSURL(string: song.sound)
        player = AVPlayer(URL: url)
        player.play()
    }
    func addDataToView(){

    }
}
