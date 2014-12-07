import UIKit
import AVFoundation
import CoreData

class SoundPlayerController: UIViewController{
    
    @IBOutlet weak var artistTxt: UILabel!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var discoLbl: UILabel!
    var list = [AnyObject]()
    var AvPlayer:AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPlaying()
        findObject()
        }
        func findObject(){
            let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            JSONData().jsonGetRequest()
            let context : NSManagedObjectContext = appDel.managedObjectContext!
            let request = NSFetchRequest(entityName: "PlayListEntity")
            request.returnsObjectsAsFaults = false
            list = context.executeFetchRequest(request, error: nil)!
            var data : NSManagedObject = list[music.currentSongInList] as NSManagedObject
            music.oneSong.artist = data.valueForKeyPath("artist") as String
            music.oneSong.title = data.valueForKeyPath("title") as String
            music.oneSong.picture = data.valueForKeyPath("picture") as String

            addDataToView()
        }
        func addDataToView(){
            titleTxt.text = music.oneSong.title
            artistTxt.text = music.oneSong.artist

            findPicture()
        }
        func findPicture() {
            
            var urlString = music.oneSong.picture
            let url = NSURL(string: urlString)
            var err: NSError?
            var imageData :NSData = NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
            let image = UIImage(data: imageData)
            let imageView = UIImageView(image: image!)
            
            imageView.frame = CGRect(x: 50, y: 100, width: 200, height: 200)
            view.addSubview(imageView)
            
    }
    func startPlaying(){
        var index = music.currentSongInList
        var data : NSManagedObject = music.playList[index] as NSManagedObject
        var songUrl = data.valueForKeyPath("preview") as? String
        let url = NSURL(string: songUrl!)
        if music.isPlaying == true{
            music.player.pause()
        }
        AvPlayer = AVPlayer(URL: url)
        println("is in player")
        AvPlayer.play()
    }
    let note = NSNotificationCenter.defaultCenter().addObserverForName(
        AVPlayerItemDidPlayToEndTimeNotification,
        object: nil,
        queue: nil,{ note in
            println(note)
            music.addOne()
            println("index fra handler: \(music.currentSongInList)")
           // music.nextView()
    })
    @IBAction func playPrev(sender: AnyObject) {
        if music.currentSongInList != 0{
        music.removeOne()
        startPlaying()
        findObject()
        }
    }
    
    @IBAction func playNext(sender: AnyObject) {
        if music.currentSongInList < music.playList.count - 1{
        music.addOne()
        startPlaying()
        findObject()
        }
    }
    @IBAction func pause(sender: AnyObject) {
        AvPlayer.pause()
    }
    @IBAction func play(sender: AnyObject) {
        AvPlayer.play()
    }
}
