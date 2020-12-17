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

class DiscordClerk {
    var streamingLink: String = "No streaming link"
    var textChannel: UInt64 = 0
    let id: Snowflake
    var movieLists: [String:Int]
    
    //Bad verbiage improve later
    ///Simple help message to be displayed to most/new  users. This message is made to make everything simple and straight forward with one list.
    var helpMessage: String = """
    Absolutely!\n
    *>openVoting* : Clears the voting list and allows users to start adding movies. \n
    *>addVote [name] (link)* : Adds a movie named [name] to the voting list. Optionally, add (link) to attach a link to the movie pick. Ex: >addVote Baby Driver https://www.fastIsBast.com \n
    *>showVotingList* or *>showWatchList* : Displays the requested list. \n
    *>dice* : Closes voting and picks a movie at random.
    """
    //Advanced features need to be re implemented later.
    ///Advanced help message to give users all the tools available from the bot.
    //    var advancedHelpMessage = """
    //    Advanced List! By default, I have a short term VotingList for picking movies in the moment and a long term WatchList for accruing choices for later. I'll also keep track of the Movies you tell me you've watched already. Here are your options for commands: \n
    //    *>addTo[list] [name] (link)* : Adds a movie named [name] to requested list. Optionally, add (link) to attach a link to the movie pick. Ex: I swear I'll add an example later. \n
    //    *>show[list]* : Displays the requested list. \n
    //    *>diceList[list]* : Selects a video at random from the WatchList instead. \n
    //    *>streamingLink* : Displays a link where everyone will go to watch the movie. My friends use Metastream https://getmetastream.com.
    //    *>setStreamingLink (link)*: Changes the streaming link to the link provided. \n
    //    """
    
    ///Creates a new instance of DiscordClerk with the given id value.
    init(snowflakeID: UInt64) {
        id = Snowflake(rawValue: snowflakeID)
        movieLists = try! db.getAllMovieLists(forClerk: snowflakeID) 
    }
    
    ///Garbage
    //    init(snowflakeID: UInt64, dbKey: Int) {
    //        id = snowflakeID
    //        dbPK = dbKey
    //    }
    
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
            addMovie(msg: msg, list: "voting") //Bad bad bad need one source of truth
        case "showvotinglist":
            msg.reply(with: displayList(list: "voting"))
        case "showwatchlist":
            openVoting(msg: msg)
        case "dice":
            dice(msg: msg, listName: "voting")
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
    }
    
    func addPick(pick: WatchPick, listName: String) {
        do {
            let _ = try db.addPickToDB(owner: id.rawValue, name: pick.title, link: pick.link, submitter: pick.submitter)
        } catch {
            print("unable to add pick \(pick.title) from location \(id.rawValue)")
        }
    }
    
    func dice(msg: Message, listName: String) {
        if try! db.getMovieList(clerkID: id.rawValue, list: listName).isEmpty {
            msg.reply(with: "Hey idiot that list is empty.")
        } else {
            msg.reply(with: "I picked *"+rollDice(forList: listName).title+"!*")
        }
        
    }
    
    func displayList(list: String) -> String {
        let watchlist = try! db.getMovieList(clerkID: id.rawValue, list: list)
        if watchlist.isEmpty {
            return "This list is empty!"
        } else {
            var formattedList: String = "", counter: Int = 1
            for pick in watchlist {
                formattedList.append("[\(counter)]: \(pick.title) \(pick.link)\n")
            }
            return formattedList
        }
        
    }
    
    func rollDice(forList list: String) -> WatchPick {
        return WatchPick()
    }
    
    func openVoting(msg: Message) {
        msg.reply(with: "Implement DiscordClerk.openVoting(msg)")
    }
    
    func setStreamingLink (link: String) -> Bool { ///Returns based on success or failure.
        if !link.isEmpty && link.contains("https://") || link.contains("www.") {
            streamingLink = link.deletingPrefix(">setStreamingLink ")
            return true
        } else {
            return false
        }
    }
    
    //    func openVoting(msg: Message) {
    //        movieLists["votingList"]!.removeAll()
    //        msg.reply(with: "A new voting list has been opened to submit Movie Picks in!")
    //        savePicks(id: id, movieLists["votingList"]!)
    //    }
    
    //    func displayList (list: String) -> String {
    //        if(movieLists[list] == nil || movieLists[list]!.isEmpty) { ///This line prevents a crash if list parameter is empty or does not exist
    //            return "Are you monkeying around? There's nothing in the watchlist!"
    //        }
    //        var printText: String = ""
    //        var count: Int = 1
    //        for movie in movieLists[list]! {
    //            printText.append("[\(count)]: " + movie.getTitle() + "\n")
    //            count+=1
    //        }
    //        return printText
    //    }
    
    func guildIDFromMessage(msg: Message) -> Int {
        return (msg.channel as! GuildChannel).guild!.id.hashValue
    }
}

