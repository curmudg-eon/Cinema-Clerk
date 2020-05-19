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
    
    addPick(title: String?, link: String? = "no link", submitter: User ) {
        movieList.append(MoviePick(title: title, link: link, submitter: submitter)
    }
    
}
