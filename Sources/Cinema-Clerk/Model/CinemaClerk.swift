import Sword
import Foundation

struct CinemaClerk {
    var streamingLink: URL? = nil
    var watchList: [MoviePick] = [] //try sets
    var votingList: [MoviePick] = []
    //var showList: [String] = []
    //var videos: [String] = []
    var textChannel: TextChannel? = nil
    
    init() {
        
    }
       
    func getWatchList () -> [MoviePick] {
        return watchList
    }
    
    mutating func addPick(pick: MoviePick) {
        watchList.append(pick)
    }
    
    mutating func setStreamingLink (link: URL?) {
        if (link != nil) {
            streamingLink = link
        }
    }
    
}
