import Sword
import Foundation

struct CinemaClerk {
    var streamingLink: URL? = nil
    var watchList: [WatchPick] = [] //try sets
    var watchedList: [WatchPick] = []
    var votingList: [WatchPick] = []
    //var showList: [String] = []
    //var videos: [String] = []
    var textChannel: TextChannel? = nil
    
    init() {
        
    }
    
    func getWatchList () -> [WatchPick] {
        return watchList
    }
    
    mutating func addPick(pick: WatchPick) {
        votingList.append(pick)
    }
    
    mutating func rollDice() -> WatchPick {
        /*Not sure if I like this functionality
         defer { //Makes it so voting list is deleted after a random item is picked to save memory & prep for next voting list
         votingList.removeAll(keepingCapacity: false)
         }*/
        if (!votingList.isEmpty) {
            return votingList.randomElement()
        } else {
            return WatchPick(title: "the watch list is empty", submitter: nil)
        }
    }
    
    
    
    mutating func setStreamingLink (link: URL?) {
        if (link != nil) {
            streamingLink = link
        }
    }
    
}
