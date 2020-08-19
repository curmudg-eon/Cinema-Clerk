import Foundation

class CinemaClerk {
    var streamingLink: String = "No streaming link"
    var movieLists: [String:[WatchPick]] = ["votingList": [WatchPick](), "watchList": [WatchPick](), "watchedList": [WatchPick]()]
    //var showList: [String] = []
    //var videos: [String] = []
    
    init() {
        
    }
    
//  This is probably dumb and won't work but I want to think about it.
//    enum lists: String {
//        case votingList = "votingList"
//        case watchList = "watchList"
//        case watchedList = "watchedList"
//    }
       
    func getList(name: String) -> [WatchPick] {
        return movieLists[name]!
    }
    
    func addPick(pick: WatchPick, listName: String) {
        movieLists[listName]!.append(pick)
    }
    
    func rollDice(list: String) -> WatchPick {
        /*Not sure if I like this functionality
        defer { //Makes it so voting list is deleted after a random item is picked to save memory & prep for next voting list
            votingList.removeAll(keepingCapacity: false)
        }*/
        movieLists["watchedList"]!.append(movieLists[list]!.randomElement()!)
        return movieLists["watchedList"]!.last!
    }
    
     func openVoting() {
        movieLists["votingList"]!.removeAll()
    }
}
