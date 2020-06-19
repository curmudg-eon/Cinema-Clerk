import Sword
import Foundation

struct CinemaClerk {
    var streamingLink: URL? = nil
    var movieList: [MoviePick] = [] //try sets
    //var showList: [String] = []
    //var videos: [String] = []
    var textChannel: TextChannel? = nil
    
    init() {
        
    }
       
    mutating func addPick(msg: Message) {
        var content = msg.content
        content = content.deletingPrefix(">addMovie ")
        if content.contains("https://") {
            var strArr = content.split(separator: " ", omittingEmptySubsequences: true)
            var link: String = String(strArr.removeLast())
            var title: String  = strArr.joined(separator: " ")
            movieList.append(MoviePick(title: title, link: link, submitter: msg.author!))
        } else {
            movieList.append(MoviePick(title: content, submitter: msg.author!))
        }

    }
    
}
