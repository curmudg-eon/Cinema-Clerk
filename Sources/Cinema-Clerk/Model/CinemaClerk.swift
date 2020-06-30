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
    
    func getVotingList () -> [WatchPick] {
        return votingList
    }

    
    mutating func addPick(pick: WatchPick) {
        votingList.append(pick)
    }
    
    mutating func rollDice() -> WatchPick {
        /*Not sure if I like this functionality
        defer { //Makes it so voting list is deleted after a random item is picked to save memory & prep for next voting list
            votingList.removeAll(keepingCapacity: false)
        }*/
        return votingList.randomElement()!
            
    }
    
    
    
    mutating func setStreamingLink (link: URL?) {
        if (link != nil) {
            streamingLink = link
        }
    }
    
}
