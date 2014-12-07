import UIKit
import AVFoundation
import CoreData

class SoundPlayerController: UIViewController{
    
    @IBOutlet weak var artistTxt: UILabel!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var discoLbl: UILabel!
    var song = music.oneSong
    var list = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.discoLbl.alpha = 0
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
            song.artist = data.valueForKeyPath("artist") as String
            song.title = data.valueForKeyPath("title") as String
            song.picture = data.valueForKeyPath("picture") as String
            println("item 1\(song.artist)")
                println("item 2\(song.title)")
                    println("item 3\(song.picture)")
            addDataToView()
        }
        func addDataToView(){
            titleTxt.text = song.title
            artistTxt.text = song.artist

            findPicture()
        }
        func findPicture() {
            
            var urlString = song.picture
            println("picture \(song.picture)")
            let url = NSURL(string: urlString)
            var err: NSError?
            var imageData :NSData = NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
            let image = UIImage(data: imageData)
            let imageView = UIImageView(image: image!)
            
            imageView.frame = CGRect(x: 50, y: 150, width: 200, height: 200)
            view.addSubview(imageView)
            
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
    @IBAction func makeAnimation(sender: AnyObject) {
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.discoLbl.alpha = 1
            
        })
        let coloredSquare = UIView()
        coloredSquare.backgroundColor = UIColor.greenColor()
        coloredSquare.frame = CGRect(x: 0, y: 120, width: 20, height: 350)
        
        self.view.addSubview(coloredSquare)
        
        let options = UIViewAnimationOptions.Repeat
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: options, animations: {
            
            coloredSquare.backgroundColor = UIColor.yellowColor()
            coloredSquare.frame = CGRect(x: 320-50, y: 120, width: 20, height: 350)
            
            }, completion: nil) 

            
        
    }
}
