import Sword
import Foundation

struct MoviePick {
    var title: String
    var link: String?
    var submitter: User
    var uniqueVoters: [User] = []
    
    mutating func addVote(user: User) -> String {
        for voter in uniqueVoters {
            if voter.username == user.username {
                return "\(user.username)) has already voted for this."
            }
        }
        uniqueVoters.append(user)
        return "\(user.username) voted for \(self.title). There are now \(uniqueVoters.count) votes for this pick."
    }
    
    init(title: String, submitter: User) {
        self.title = title
        self.link = nil
        self.submitter = submitter
        uniqueVoters.append(submitter)
    }
    
    init(title: String, link: String, submitter: User) {
        self.title = title
        self.link = link
        self.submitter = submitter
        uniqueVoters.append(submitter)
    }
    
}
