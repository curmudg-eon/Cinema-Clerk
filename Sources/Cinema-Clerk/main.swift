import Sword

let bot = Sword(token: Token) //Replace Token with your bot's token string 
let clerk = CinemaClerk()


// https://discord.com/api/oauth2/authorize?client_id=700835705647136828&permissions=804384528&scope=bot for re-adding bot in testing

bot.editStatus(to: "online", watching: ">help")

bot.on(.messageCreate) { data in //Message Handler
    let msg = data as! Message
    
    if msg.content.hasPrefix(">")  {
        //var f = msg.content.firstIndex(of: "p")
        let content = msg.content.lowercased()
        switch content {
        case ">help":
            helpMessage(msg: msg)
        case ">addMovie":
            addMovie(msg: msg)
        default:
            msg.reply(with: "Failure")
        }
        
        
    }
}

func helpMessage(msg: Message) {
    msg.reply(with:"""
```
Very well, here are your options:
>help : Get a list of commands this bot can execute. \n
>openVoting : Opens a new watchlist for users to add movies. \n
>addMovie [name] (link) : Adds a movie named [name] to current watchlist. Optionally, add (link) to attach a link to the movie. \n
>dice : closes voting on current watchlist and picks a movie at random. \n
```
""")
}

func addMovie(msg: Message) {
    var content = msg.content
    content = msg.content
    clerk.addPick(title: content, submitter: msg.author)
    msg.reply(with: "\(msg.author)'s pick has been added to the watchlist.")
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
