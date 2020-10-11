//
//  DiscordClerk.swift
//
//  This class acts as a clerk that handles all the requests for a set of users. In the context of discord,
//  that can mean a server, a group chat, or a single user in a direct message with the bot. 
//
//
//  Created by Gabe Secula on 7/11/20.
//

import Foundation
import Sword

class DiscordClerk: CinemaClerk, Codable {
    var textChannel: UInt64 = 0
    let id: UInt64
    
    ///
    var helpMessage: String = """
    ```
    Absolutely! By default, I have a short term VotingList for picking movies in the moment and a long term WatchList for accruing choices for later. I'll also keep track of the Movies you tell me you've watched already. Here are your options for commands: \n
    *>openVoting* : Clears the previous votinglist and allows users to start adding movies. \n
    *>addVote [name] (link)* or *>addWatchPick [name] (link)* : Adds a movie named [name] to requested list. Optionally, add (link) to attach a link to the movie pick. Ex: >addVote Baby Driver https://www.fastIsBast.com \n
    *>showVotingList* or *>showWatchList* : Displays the requested list. \n
    *>dice* : Closes voting on current Voting List and picks a movie at random.
    *>diceWatchList* : Selects a video at random from the WatchList instead. \n
    *>streamingLink* : Displays a link where everyone will go to watch the movie. My friends use Metastream https://getmetastream.com.
    *>setStreamingLink (link)*: Changes the streaming link to the link provided. \n
    ```
    """
    
    ///Creates a new instance of DiscordClerk with the given id value.
    init(snowflakeID: UInt64) {
        id = snowflakeID
    }
    
    ///Sets the given Discord text channel as the channel to be used for interactions with the bot.
    func setTextChannel (textChl: GuildText) {
        textChannel = textChl.id.rawValue
    }
    
    ///Parses and responds to a Discord Message
    func handleMessage (msg: Message) {
        let prefix = String(msg.content.lowercased().split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).first!).deletingPrefix(">")
        switch prefix {
        case "help":
            msg.reply(with: helpMessage)
        case "addvote":
            addMovie(msg: msg, list: "votingList")
        case "addwatchpick":
            addMovie(msg: msg, list: "watchList")
        case "showvotinglist":
            msg.reply(with: displayList(list: "votingList"))
        case "showwatchlist":
            msg.reply(with: displayList(list: "watchList"))
        case "openvoting":
            openVoting(msg: msg)
        case "dice":
            dice(msg: msg, listName: "votingList")
        case "dicewatchlist":
            dice(msg: msg, listName: "watchList")
        case "streaminglink":
            msg.reply(with: "The streaming link is: \(streamingLink)")
        case "setstreaminglink":
            msg.reply(with: setStreamingLink(link: msg.content) ? "Streaming link has been set! " : "The link provided didn't seem to work. Make sure it's a proper web link.")
        case "credits", "rollcredits":
            msg.reply(with: "A Discord bot by gabeSecula https://github.com/gabeSecula \nArtwork for *Clark the Clerk* by Barbara Chernyavsky https://www.instagram.com/obabsu/")
        default:
            msg.reply(with: "Were you trying to reach me? I didn't get that. Try *>help*")
        }
    }
    
    ///
    func addMovie(msg: Message, list: String) {
        var title: String = msg.content
        title = title.deletingPrefix(">addVote ")
        title = title.deletingPrefix(">addWatchPick ")
        var link: String = "No link provided"
        
        if title.contains("https://") || title.contains("www.") {
            var strArr = title.split(separator: " ", omittingEmptySubsequences: true)
            link = String(strArr.removeLast())
            title = strArr.joined(separator: " ")
            addPick(pick: WatchPick(title: title, link: link, submitter: msg.author!.username!), listName: list)
            msg.reply(with: """
                \(msg.author!.username!) added *\(title)* to the watchlist.
                Link: \(link)
                """)
        } else {
            addPick(pick: WatchPick(title: title, submitter: msg.author!.username!), listName: list)
            msg.reply(with: "\(msg.author!.username!) added *\(title)* to the watchlist.")
        }
//        savePicks(id: id, movieLists["votingList"]!)
    }
    
    func dice(msg: Message, listName: String) {
        if movieLists[listName]!.isEmpty {
            msg.reply(with: "Hey idiot that list is empty.")
        } else {
            msg.reply(with: "I picked *"+rollDice(list: listName).title+"!*")
        }
        
    }
    
    func setStreamingLink (link: String) -> Bool { ///Returns based on success or failure.
        if !link.isEmpty && link.contains("https://") || link.contains("www.") {
            streamingLink = link.deletingPrefix(">setStreamingLink ")
            return true
        } else {
            return false
        }
    }
    
    func openVoting(msg: Message) {
        movieLists["votingList"]!.removeAll()
        msg.reply(with: "A new voting list has been opened to submit Movie Picks in!")
//        savePicks(id: id, movieLists["votingList"]!)
    }
    
    func displayList (list: String) -> String {
        if(movieLists[list]!.isEmpty) {
            return "Are you monkeying around? There's nothing in the watchlist!"
        }
        var printText: String = ""
        var count: Int = 1
        for movie in movieLists[list]! {
            printText.append("[\(count)]: " + movie.getTitle() + "\n")
            count+=1
        }
        return printText
    }
    
    /*Features for later
    func bump (title: String) {
    upvote a pick on
    }
    func showEntries () {
    show all entries a person has made
    }
    */
    
    func guildIDFromMessage(msg: Message) -> Int {
        return (msg.channel as! GuildChannel).guild!.id.hashValue
    }
}

