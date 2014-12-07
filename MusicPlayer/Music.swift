import Foundation
import UIKit
import AVFoundation
var music: Music = Music()

struct song{
    var title = ""
    var artist = ""
    var picture = ""
    var sound = ""
}

class Music : NSObject{


    var songs = [song]()
    var oneSong = song()
    var currentSongInList :Int = 3;
    var songsPlaying = [AnyObject]()
    var playList = [AnyObject]()
    var player:AVQueuePlayer!
    
    func addSong(title : String, artist : String, picture : String, sound : String){
        songs.append(song(title: title, artist: artist, picture: picture, sound: sound))
    }
    func addOne(){
        currentSongInList++
        println("Added i music \(currentSongInList)")
        
    }
    func removeOne(){
        currentSongInList--
        println("Added i music \(currentSongInList)")
    }
    func nextView(){
        SoundPlayerController().findObject()
    }
}
