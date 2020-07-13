import Sword

/*
 Main.swift is a bot that interfaces with Discord services using the Sword library.
 The purpose of this bot is just to manage a group of friends' movie picks and watchlists.
 The backend code used to manage the actual picks and data is separated in order to allow for later development into a full stack Appleß app.
 
 */

// https://discord.com/api/oauth2/authorize?client_id=700835705647136828&permissions=804384528&scope=bot for re-adding bot in testing - bot is currently only available to add by author


let bot = Sword(token: Token) //Replace Token with your bot's token string 
var manager: [Int:DiscordClerk] = [:]


//I need to do this to check if the bot has record of every server it's a part of.
bot.on(.ready) { data in
    bot.editStatus(to: "online", watching: ">help")
    for guild in bot.guilds {
        if manager.keys.contains(guild.key.hashValue) {
            continue
        } else {
            addGuildToClientele(guild: guild.value)
        }
        
    }
}

bot.on(.guildCreate) { data in
    let guild = data as! Guild
    addGuildToClientele(guild: guild)
    //From here add a new Guild Category called Movie Night that includes voice channel Movie Theatre and Text Channel Movie Picks
}

//bot.on(.guildMemberAdd) - I have the power to annoy people to no end and plug my own bot with this. "You and me Spidaman, we could rule this city Spidaman!" -Videogamedunkey

/// This sorts all messages that the bot receives and passes them along to the proper DiscordClerk instance.
bot.on(.messageCreate) { data in
    let msg = data as! Message
    if msg.content.hasPrefix(">")  {   /// Check for prefix before running rest of conditionals
        if msg.channel.type == .guildText {  ///  Make sure users aren't sliding in bot dm's
            manager[guildIDFromMessage(msg: msg)]?.handleMessage(msg: msg)
        } else if  msg.channel.type == .groupDM {
            manager[msg.channel.id.hashValue]?.handleMessage(msg: msg)
        } else if msg.channel.type == .dm {
            manager[msg.author!.id.hashValue]?.handleMessage(msg: msg)
        }
    }
}


///Helper Functions Follow

func addGuildToClientele(guild: Guild) {
    manager[guild.id.hashValue] = DiscordClerk(guild: guild)
}

func guildIDFromMessage(msg: Message) -> Int {
    return (msg.channel as! GuildChannel).guild!.id.hashValue
}

/*Features for later
 func bump (title: String) {
 upvote a pick on
 }
 func showEntries () {
 show all entries a person has made
 }
 */

bot.editStatus(to: "online", watching: ">help")
bot.connect()


