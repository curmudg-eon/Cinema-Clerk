import Sword

let bot = Sword(token: Token) //Replace Token with your bot's token string 
var theatreChannel: Channel


bot.editStatus(to: "online", watching: ">help")

bot.on(.messageCreate) { data in //Message Handler
    let msg = data as! Message
    
    if msg.content.hasPrefix(">")  {
        var content = msg.content.lowercased()
        if content.hasPrefix(">help") {
            reply(msg: msg)
        }
        
    }
}

func reply(msg: Message) {
    
}

bot.connect()
