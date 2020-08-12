import Foundation

class CinemaClerk {
    var streamingLink: String = "No streaming link"
    var movieLists: [String:[WatchPick]] = ["votingList": [WatchPick](), "watchList": [WatchPick](), "watchedList": [WatchPick]()]
    //var showList: [String] = []
    //var videos: [String] = []
    
    init() {
        
    }
    
    enum lists: String {
        case votingList = "votingList"
        case watchList = "watchList"
        case watchedList = "watchedList"
    }
       
    func getList(name: String) -> [WatchPick] {
        return movieLists[name]!
    }
    
    func addPick(pick: WatchPick, list: lists) {
        movieLists[list].append(pick)
    }
    
    func rollDice(list: lists) -> WatchPick {
        /*Not sure if I like this functionality
        defer { //Makes it so voting list is deleted after a random item is picked to save memory & prep for next voting list
            votingList.removeAll(keepingCapacity: false)
        }*/
        movieLists[lists.watchedList].append(movieLists[list].randomElement()!)
        return movieLists[list].last!
            
    }
    
     func openVoting() {
        votingList.removeAll()
    }
}
