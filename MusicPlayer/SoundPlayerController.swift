import UIKit
import AVFoundation
import CoreData

class SoundPlayerController: UIViewController{
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var artistText: UILabel!
    
    var song = music.oneSong
    var list = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        JSONData().jsonGetRequest()
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "PlayListEntity")
        request.returnsObjectsAsFaults = false
        list = context.executeFetchRequest(request, error: nil)!
        startPlaying()
        findObject()
        }
        func findObject(){
            var data : NSManagedObject = list[music.currentSongInList] as NSManagedObject
            song.artist = data.valueForKeyPath("artist") as String
            song.title = data.valueForKeyPath("title") as String
            song.picture = data.valueForKeyPath("picture") as String
            println("item 1\(song.artist)")
                println("item 2\(song.title)")
                    println("item 3\(song.picture)")
            addDataToView()
        }
        func addDataToView(){
            titleText.text = song.title
            artistText.text = song.artist
            findPicture()
        }
        @IBOutlet weak var picture: UIImageView!
        func findPicture() {
            /*if let url = NSURL(string: song.picture){
                println("image: \(url)")
                if let image = UIImage(data: NSData(contentsOfURL: url)!){
                    picture = UIImageView(image: image)
                }
            }*/
            
            let url = NSURL(string: song.picture);
            var err: NSError?
            var imageData :NSData = NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
                var image = UIImage(data:imageData)
            
            picture = UIImageView(image: image)
            
    }
    func startPlaying(){
        music.songsPlaying.removeAll()
        var index = music.currentSongInList
        println("index: \(index) og listetørrelse er: \(music.playList.count)")
        for index in index...music.playList.count-1{
            var data : NSManagedObject = music.playList[index] as NSManagedObject
            var songUrl = data.valueForKeyPath("preview") as? String
            let url = NSURL(string: songUrl!)
            music.songsPlaying.append(AVPlayerItem(URL: url!))
        }
        music.player = AVQueuePlayer(items: music.songsPlaying)
        println("is in player")
        music.player.play()
        println("is in player after play")
    }

    @IBAction func playPrev(sender: AnyObject) {
        music.removeOne()
        startPlaying()
        findObject()
    }
    
    @IBAction func playNext(sender: AnyObject) {
        music.addOne()
        startPlaying()
        findObject()
    }
    @IBAction func pause(sender: AnyObject) {
        music.player.pause()
    }
    @IBAction func play(sender: AnyObject) {
        music.player.play()
    }
}
