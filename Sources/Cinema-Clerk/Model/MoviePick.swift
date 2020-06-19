import Sword
import Foundation

struct MoviePick {
    var title: String
    var link: String?
    var submitter: User
    var uniqueVoters: [User] = []
    //try a tuple
    mutating func addVote(user: User) -> String {
        for voter in uniqueVoters {
            if voter.username == user.username {
                return "\(user.username)) has already voted for this."
            }
        }
        uniqueVoters.append(user)
        return "\(user.username) voted for \(self.title). There are now \(uniqueVoters.count) votes for this pick."
    }
    
    init(title: String = "title somehow goofed?", link: String = "No Link provided", submitter: User) {
        self.title = title
        self.link = link
        self.submitter = submitter
        uniqueVoters.append(submitter)
    }
    
}
