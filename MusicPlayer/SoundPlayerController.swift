import UIKit
import AVFoundation
import CoreData

class SoundPlayerController: UIViewController{
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var artistText: UILabel!
    
    var player:AVPlayer!
    var song = music.oneSong
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleText.text = song.title
        artistText.text = song.artist
    }
    override func viewDidAppear(animated: Bool)
    {
    }
    func playSong(){
        let url = NSURL(string: song.sound)
        player = AVPlayer(URL: url)
        player.play()
    }
    func addDataToView(){

    }
}
