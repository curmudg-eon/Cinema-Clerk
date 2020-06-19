import Sword

let bot = Sword(token: Token) //Replace Token with your bot's token string 
var clerk = CinemaClerk()


// https://discord.com/api/oauth2/authorize?client_id=700835705647136828&permissions=804384528&scope=bot for re-adding bot in testing

bot.editStatus(to: "online", watching: ">help")

bot.on(.messageCreate) { data in //Message Handler
    let msg = data as! Message
    
    if msg.content.hasPrefix(">")  {
        //var f = msg.content.firstIndex(of: "p")
        let content = msg.content.lowercased()

        if content.hasPrefix(">help") {
            helpMessage(msg: msg)
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

func helpMessage(msg: Message) {
    msg.reply(with:"""
```
Very well, here are your options:
>help : Get a list of commands this bot can execute. \n
>openVoting : Opens a new watchlist for users to add movies. \n
>addMovie [name] : Adds a movie named [name] to current watchlist.\n
>dice : closes voting on current watchlist and picks a movie at random. \n
```
""")
    //>addMovie [name] (link) : Adds a movie named [name] to current watchlist. Optionally, add (link) to attach a link to the movie. \n
}

func addMovie(msg: Message) {
    let content = String(msg.content)
    var tempIndex = content.firstIndex(of: " ") ?? content.endIndex
    var pick = String(content[tempIndex...])
    clerk.addPick(msg: msg)
    msg.reply(with: "```@\(msg.author!.username!) added\(pick) to the watchlist.```")
    msg.delete()
}


 func openVoting(msg: Message) {
     
 }
 /*
 func dice(msg: Message) {
     
 }
 
 func addMovie(msg: Message) {
     
 }
 
*/

bot.connect()
print("connected as \(bot)")
