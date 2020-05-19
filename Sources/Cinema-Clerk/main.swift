import Sword

let bot = Sword(token: Token) //Replace Token with your bot's token string 
var theatreChannel: Channel


bot.editStatus(to: "online", watching: ">help")

bot.on(.messageCreate) { data in //Message Handler
    let msg = data as! Message
    
    if msg.content.hasPrefix(">")  {
        var f = msg.content.firstIndex(of: "p")
        var content = msg.content.lowercased()
        switch content {
        case ">help":
            helpMessage(msg: msg)
        default:
            msg.reply(with: "Failure")
        }
        
        /*
        if content.hasPrefix(">help") {
            helpMessage(msg: msg)
        }*/
        
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

bot.connect()
print("connected as \(bot)")
