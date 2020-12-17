import Sword

/*
 Gabe Secula
 Main.swift is a bot that interfaces with Discord services using the Sword library.
 The purpose of this bot is to manage a group of friends' movie picks and watchlists.
 */

// https://discord.com/api/oauth2/authorize?client_id=700835705647136828&permissions=804384528&scope=bot for re-adding bot in testing - bot is currently only available to add by author as it is not hosted on a server.


let bot = Sword(token: Token) ///Replace Token with your bot's token string
let db = Database()
var manager: [UInt64:DiscordClerk] = try db.getClerkList() //Pulls list from Database or an empty list if the list is empty.
//manager.
bot.on(.ready) { data in
    bot.editStatus(to: "online", watching: ">help")
}

/// Proactively adds an entry when the bot enters a server
bot.on(.guildCreate) { data in
    let guild = data as! Guild
    addToClientele(id: guild.id.rawValue) //I know it's unused leave me alone compiler
    //From here add a new Guild Category called Movie Night that includes voice channel Movie Theatre and Text Channel Movie Picks
}

/// Remove entry when the bot leaves a server
bot.on(.guildDelete) { data in
    let guild = data as! Guild
    manager.removeValue(forKey: guild.id.rawValue)
}

//bot.on(.guildMemberAdd) - I have the power to annoy people to no end and plug my own product more often than a late night tv infomercial with this.

/// This sorts all messages that the bot receives and passes them along to the proper DiscordClerk instance.
bot.on(.messageCreate) { data in
    let msg = data as! Message
    if msg.content.hasPrefix(">")  {   /// Check for prefix before running rest of conditionals
        if manager.keys.contains(msg.idOfLocation()) {
            manager[msg.idOfLocation()]?.handleMessage(msg: msg)
        } else {
            addToClientele(id: msg.idOfLocation()) ///If clerk  exists -> handle the message. If clerk does not exist -> create clerk and handles message
            manager[msg.idOfLocation()]?.handleMessage(msg: msg)
        }
    } else if msg.content.hasPrefix(")") { //This is just scaffolding for testing state right now.
        msg.reply(with: "# of clerks: \(manager.count)")
        for clerk in manager {
            msg.reply(with: "Key: \(clerk)")
        }
    }
}


///Helper Functions Follow

func addToClientele(id: UInt64) {
    do {
        let _ = try db.addClerkToDB(snowflakeID: id)
    } catch {
        print("Unable to add client \(id) to database.")
    }
}

bot.connect()
