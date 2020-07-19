//
//  DiscordClerk.swift
//  
//
//  Created by Gabe Secula on 7/11/20.
//

import Foundation
import Sword

class DiscordClerk: CinemaClerk {
    var textChannel: GuildText?
    let id: Int
    
    let helpMessage = """
    ```
    Absolutely! Here are your options: \n
    >help : Get a list of commands this bot can execute. \n
    >openVoting : Clears the previous watchlist and allows users to start adding movies. \n
    >addMovie [name] (link) : Adds a movie named [name] to current watchlist. Optionally, add (link) to attach a link to the movie pick. Ex: >addMovie Baby Driver https://www.fastIsBast.com \n
    >showList : Displays the
    >dice : Closes voting on current watchlist and picks a movie at random. \n
    >streamingLink : Displays a link where everyone will go to watch the movie. My friends use Metastream https://getmetastream.com. \n
    >setStreamingLink (link): Changes the streaming link to the link provided.
    ```
    """
    
    
    init(snowflakeID: Int) {
        id = snowflakeID
    }
    
    func setTextChannel (textChl: GuildText) {
        textChannel = textChl
    }
    
    func handleMessage (msg: Message) {
        let prefix = String(msg.content.lowercased().split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).first!).deletingPrefix(">")
        switch prefix {
        case "help":
            msg.reply(with: helpMessage)
        case "addmovie":
            addMovie(msg: msg)
        case "showlist", "showwatchlist":
            msg.reply(with: displayWatchList())
        case "openvoting":
            openVoting()
            msg.reply(with: "A new voting list has been opened to submit Movie Picks in!")
        case "dice":
            dice(msg: msg)
        case "streaminglink":
            msg.reply(with: "The streaming link is: \(streamingLink)")
        case "setstreaminglink":
            msg.reply(with: setStreamingLink(link: msg.content) ? "Streaming link has been set to \(streamingLink) !" : "The link provided didn't seem to work. Make sure it's a proper web link.")
        default:
            msg.reply(with: "Were you trying to reach me? I didn't get that. Try *>help*")
        }
    }
    
    
    func addMovie(msg: Message) {
        var title: String = msg.content
        title = title.deletingPrefix(">addMovie ")
        var link: String = "No link provided"
        
        if title.contains("https://") || title.contains("www.") {
            var strArr = title.split(separator: " ", omittingEmptySubsequences: true)
            link = String(strArr.removeLast())
            title = strArr.joined(separator: " ")
            addPick(pick: WatchPick(title: title, link: link, submitter: msg.author!.username!))
            msg.reply(with: """
                \(msg.author!.username!) added *\(title)* to the watchlist.
                Link: \(link)
                """)
        } else {
            addPick(pick: WatchPick(title: title, submitter: msg.author!.username!))
            msg.reply(with: "\(msg.author!.username!) added *\(title)* to the watchlist.")
        }
    }
    
    func dice(msg: Message) {
        if votingList.isEmpty {
            msg.reply(with: "Hey idiot the voting list is empty.")
        } else {
            msg.reply(with: "I picked *"+rollDice().pick.title+"!*")
        }
        
    }
    
    func displayWatchList () -> String {
        if(votingList.isEmpty) {
            return "Are you monkeying around? There's nothing in the watchlist!"
        }
        var printText: String = ""
        var count: Int = 1
        for movie in votingList {
            printText.append("[\(count)]: " + movie.getTitle() + "\n")
            count+=1
        }
        return printText
    }
    
    func guildIDFromMessage(msg: Message) -> Int {
        return (msg.channel as! GuildChannel).guild!.id.hashValue
    }
}

