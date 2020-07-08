import Sword
import Foundation

//Not sure I even need to make this into a struct. I honestly think the whole thing could be a tuple as of its usage right now but not sure how to do it elegantly.

struct WatchPick {
    var pick: (title:String, link:String, submitter: String)
    var uniqueVoters: [String] = [] //For later if I want to add the ability to bump votes
    
    /*mutating func addVote(user: User) -> Bool {
        if uniqueVoters.contains(user) {
            return false //"\(user.username)) has already voted for this."
        } else {
            uniqueVoters.append(user)
            return true //"\(user.username) voted for \(self.pick.title). There are now \(uniqueVoters.count) votes for this pick."
        }
    }*/
    
    //Useless
    func getTitle () -> String {
        return pick.title
    }
    
    init(title: String = "No Title Provided", link: String = "", submitter: String = "Unknown User") {
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
