import Sword
import Foundation

struct MoviePick {
    var pick: (title:String, link:String, submitter: User)
    
    var uniqueVoters: [User] = []
    
    /*mutating func addVote(user: User) -> Bool {
        if uniqueVoters.contains(user) {
            return false //"\(user.username)) has already voted for this."
        } else {
            uniqueVoters.append(user)
            return true //"\(user.username) voted for \(self.pick.title). There are now \(uniqueVoters.count) votes for this pick."
        }
    }*/
    
    init(title: String = "title somehow goofed?", link: String = "No Link provided", submitter: User) {
        self.pick = (title: title, link: link, submitter: submitter)
        uniqueVoters.append(submitter)
    }
    
}
