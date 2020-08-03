import Sword

/*
 Main.swift is a bot that interfaces with Discord services using the Sword library.
 The purpose of this bot is just to manage a group of friends' movie picks and watchlists.
 The backend code used to manage the actual picks and data is separated in order to allow for later development into a full stack Appleß app.
 
 */

// https://discord.com/api/oauth2/authorize?client_id=700835705647136828&permissions=804384528&scope=bot for re-adding bot in testing - bot is currently only available to add by author


let bot = Sword(token: Token) //Replace Token with your bot's token string 
var manager: [UInt64:DiscordClerk] =  loadFromJSON() ?? [:] /// Load if there's data, create an empty Dictionary otherwise.
for clerk in manager {
    clerk.value.loadWatchPicks()
}
bot.on(.ready) { data in
    bot.editStatus(to: "online", watching: ">help")
}

bot.on(.guildCreate) { data in
    let guild = data as! Guild
    addToClientele(id: guild.id.rawValue)
    //From here add a new Guild Category called Movie Night that includes voice channel Movie Theatre and Text Channel Movie Picks
}

//bot.on(.guildMemberAdd) - I have the power to annoy people to no end and plug my own bot with this. "You and me Spidaman, we could rule this city Spidaman!" -Videogamedunkey

/// This sorts all messages that the bot receives and passes them along to the proper DiscordClerk instance.
bot.on(.messageCreate) { data in
    let msg = data as! Message
    if msg.content.hasPrefix(">")  {   /// Check for prefix before running rest of conditionals
        (manager[msg.idOfLocation()] ?? addToClientele(id: msg.idOfLocation())).handleMessage(msg: msg)
    } else if msg.content.hasPrefix(")") {
        msg.reply(with: "# of clerks: \(manager.count)")
        for clerk in manager {
            msg.reply(with: "Key: \(clerk.key)")
        }
    }
    saveToJSON(manager)
}


///Helper Functions Follow

func addToClientele(id: UInt64) -> DiscordClerk {
    manager[id] = DiscordClerk()
    return manager[id]!
}

//func guildFromMessage(msg: Message) -> Guild {
//    return (msg.channel as! GuildChannel).guild!
//}
//
//func guildIDFromMessage(msg: Message) -> Int {
//    return (msg.channel as! GuildChannel).guild!.id.hashValue
//}

bot.connect()

//Fatal error: Unexpectedly found nil while unwrapping an Optional value: file /Users/gabesecula/Documents/Code/Cinema-Clerk/.build/checkouts/Sword/Sources/Sword/Gateway/GatewayHandler.swift, line 46
//Illegal instruction: 4
