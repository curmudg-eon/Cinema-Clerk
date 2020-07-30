import Foundation

class CinemaClerk {
    var streamingLink: String = "No streaming link"
    var watchList: [WatchPick] = [] //try sets
    var watchedList: [WatchPick] = []
    var votingList: [WatchPick] = []
    //var showList: [String] = []
    //var videos: [String] = []
    
    init() {
        
    }
       
    func getWatchList () -> [WatchPick] {
        return watchList
    }
    
    func getVotingList () -> [WatchPick] {
        return votingList
    }

    
     func addPick(pick: WatchPick) {
        votingList.append(pick)
    }
    
     func rollDice() -> WatchPick {
        /*Not sure if I like this functionality
        defer { //Makes it so voting list is deleted after a random item is picked to save memory & prep for next voting list
            votingList.removeAll(keepingCapacity: false)
        }*/
        watchedList.append(votingList.randomElement()!)
        return watchedList.last!
            
    }
    
     func openVoting() {
        votingList.removeAll()
    }
}
