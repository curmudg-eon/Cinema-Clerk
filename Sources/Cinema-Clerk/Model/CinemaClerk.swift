import Sword
import Foundation

struct CinemaClerk {
    var streamingLink: URL? = nil
    var movieList: [MoviePick] = []
    //var showList: [String] = []
    //var videos: [String] = []
    var textChannel: TextChannel? = nil
    
    init() {
        
    }
    
    mutating func addPick(msg: Message) {
        var content = msg.content
        movieList.append(MoviePick(title: content, submitter: msg.author!))
    }
    
}
