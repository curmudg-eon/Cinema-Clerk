import Foundation

class CinemaClerk {
    var streamingLink: String = "No streaming link"
    var movieLists: [String:[WatchPick]] = ["votingList": [WatchPick](), "watchedList": [WatchPick]()]
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
        movieLists[listName]?.append(pick)
    }
    
    func rollDice(list: String) -> WatchPick {
        movieLists["watchedList"]!.append(movieLists[list]!.randomElement()!)
        return movieLists["watchedList"]!.last!
    }
    
     func openVoting() {
        movieLists["votingList"]!.removeAll()
    }
}
