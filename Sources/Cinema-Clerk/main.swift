import Sword

let bot = Sword(token: Token) //Replace Token with your bot's token string 
let helpMessage = """
```
Very well, here are your options:
>help : Get a list of commands this bot can execute. \n
>openVoting : Opens a new watchlist for users to add movies. \n
>addMovie [name] (link) : Adds a movie named [name] to current watchlist. Optionally, add (link) to attach a link to the movie. \n
>dice : closes voting on current watchlist and picks a movie at random. \n
```
"""


var clerk = CinemaClerk()



// https://discord.com/api/oauth2/authorize?client_id=700835705647136828&permissions=804384528&scope=bot for re-adding bot in testing

bot.editStatus(to: "online", watching: ">help")

bot.on(.messageCreate) { data in //Message Handler
    let msg = data as! Message
    
    if msg.content.hasPrefix(">")  {
        let content = msg.content.lowercased()
        
        if content.hasPrefix(">help") { //This could potentially be a switch statement? That may be less memory efficient.
            msg.reply(with: helpMessage)
        } else if content.hasPrefix(">addmovie") {
            addMovie(msg: msg)
        } else if content.hasPrefix(">showlist") || content.hasPrefix(">showwatchlist") {
            msg.reply(with: displayWatchList())
        } else {
            msg.reply(with: "Were you trying to reach me? I didn't get that. Try *>help*")
        }
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
        clerk.addPick(pick: WatchPick(title: title, link: link, submitter: msg.author!))
        msg.reply(with: """
        \(msg.author!.username!) added *\(title)* to the watchlist.
        Link: \(link)
        """)
    } else {
        clerk.addPick(pick: WatchPick(title: title, submitter: msg.author!))
        msg.reply(with: """
        \(msg.author!.username!) added *\(title)* to the watchlist.
        """)
    }
   
    //msg.delete() //I'm not sure how I feel about this. Deleting the user message makes chat cleaner, but it also removes other users' ability to see what commands can be used to do what. If I leave the message it's like a little invitation to play with the bot
}

func displayWatchList () -> String {
    if(clerk.getWatchList().isEmpty) {
        return "Are you monkeying around? There's nothing in the watchlist!"
    }
    var printText: String = ""
    var count: Int = 1
    for movie in clerk.getWatchList() {
        printText.append("[\(count)]: " + movie.getTitle() + "\n")
        count+=1
    }
    return printText
}

func openVoting(msg: Message) {
    
}

func dice(msg: Message) {
    msg.reply(with: "I picked *"+clerk.rollDice().pick.title+"!*")
}

/*Features for later
 func bump (title: String) {
    upvote a pick on
 }
 func showEntries () {
    show all entries a person has made
 }
*/


 


bot.connect()
print("connected as \(bot)")
