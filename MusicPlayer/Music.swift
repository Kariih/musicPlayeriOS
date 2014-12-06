import Foundation
import UIKit

var music: Music = Music()

struct song{
    var title = ""
    var artist = ""
    var picture = ""
    var sound = ""
}

class Music : NSObject{

    var songs = [song]()
    
    func addSong(title : String, artist : String, picture : String, sound : String){
        songs.append(song(title: title, artist: artist, picture: picture, sound: sound))
    }
}