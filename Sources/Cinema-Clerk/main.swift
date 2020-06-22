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
        
        if content.hasPrefix(">help") {
            msg.reply(with: helpMessage)
        } else if content.hasPrefix(">addmovie") {
            addMovie(msg: msg)
        } else {
            msg.reply(with: "Were you trying to reach me? I didn't get that.")
        }
        
        
        
        
        /*Swap to switch at some point if it makes sense
         switch content {
         case ">help":
         helpMessage(msg: msg)
         case ">addmovie":
         addMovie(msg: msg)
         default:
         msg.reply(with: "Failure")
         }
         */
        
        
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
        clerk.addPick(pick: MoviePick(title: title, link: link, submitter: msg.author!))
        msg.reply(with: """
        \(msg.author!.username!) added *\(title)* to the watchlist.
        Link: \(link)
        """)
    } else {
        clerk.addPick(pick: MoviePick(title: title, submitter: msg.author!))
        msg.reply(with: """
        \(msg.author!.username!) added *\(title)* to the watchlist.
        """)
    }
   
    //msg.delete()
}

func displayWatchList () {
    
}

func openVoting(msg: Message) {
    
}

func dice(msg: Message) {
    
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
