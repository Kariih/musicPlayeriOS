
import Foundation
import UIKit


class JSONData {
    
    init(){
    }
    
    func jsonGetRequest(){
       
        let url = NSURL(string: "https://api.spotify.com/v1/search?q=sexy&type=track")
        println(url)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data,options:nil,error: nil) {
                if let res = jsonResult as? NSDictionary {
                    let track = res["tracks"] as NSDictionary
                        let tracks = track["items"] as NSArray
                        for t in tracks{
                            let title = t["name"] as NSString
                            let sound = t["preview_url"] as NSString
                            let artists = t["artists"] as NSArray
                            let artist = artists[0]["name"] as NSString
                            let album = t["album"] as NSDictionary
                            let images = album["images"] as NSArray
                            let picture = images[2]["url"] as NSString
                            music.addSong(title, artist: artist, picture: picture, sound: sound)
                        }
                    
                }
            }
        })
        task.resume()
    }
}