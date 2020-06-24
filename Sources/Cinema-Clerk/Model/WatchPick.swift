import Sword
import Foundation

struct WatchPick {
    var pick: (title:String, link:String, submitter: User)
    var uniqueVoters: [User] = [] //For later if I want to add the ability to bump votes
    
    /*mutating func addVote(user: User) -> Bool {
        if uniqueVoters.contains(user) {
            return false //"\(user.username)) has already voted for this."
        } else {
            uniqueVoters.append(user)
            return true //"\(user.username) voted for \(self.pick.title). There are now \(uniqueVoters.count) votes for this pick."
        }
    }*/
    
    func getTitle () -> String {
        return pick.title
    }
    
    init(title: String = "No Title Provided", link: String = "", submitter: User) {
        self.pick = (title: title, link: link, submitter: submitter)
        uniqueVoters.append(submitter)
    }
    
    /*Not quite sure if this will be useful
     func details(verbose: Bool) -> String[] {
        if verbose {
            
        } else {
            if pick.link.isEmpty {
                return
            } else {
                return {pick.title}
            }
        }
        
    }*/
    
}
