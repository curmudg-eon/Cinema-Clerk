import Sword

/*
 Main.swift is a bot that interfaces with Discord services using the Sword library.
 The purpose of this bot is just to manage a group of friends' movie picks and watchlists.
 The backend code used to manage the actual picks and data is separated in order to allow for later development into a full stack Appleß app.
 
 */

// https://discord.com/api/oauth2/authorize?client_id=700835705647136828&permissions=804384528&scope=bot for re-adding bot in testing - bot is currently only available to add by author


let bot = Sword(token: Token) //Replace Token with your bot's token string 

let helpMessage = """
```
Very well, here are your options: \n
>help : Get a list of commands this bot can execute. \n
>openVoting : Clears the previous watchlist and allows users to start adding movies. \n
>addMovie [name] (link) : Adds a movie named [name] to current watchlist. Optionally, add (link) to attach a link to the movie pick. Ex: >addMovie Baby Driver https://www.fastIsBast.com \n
>dice : Closes voting on current watchlist and picks a movie at random. \n
>streamingLink : Displays a link where everyone will go to watch the movie. My friends use Metastream https://getmetastream.com. \n
>setStreamingLink (link): Changes the streaming link to the link provided.
```
"""

var manager: [Int:CinemaClerk] = [0:CinemaClerk()]
var clerk = CinemaClerk()
//I need to do this to check if the bot has record of every server it's a part of.
bot.on(.ready) { data in
    let user = data as! User
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

/// This handles all messages that the bot receives.
bot.on(.messageCreate) { data in
    let msg = data as! Message
    if !(msg.channel.type == .dm) {//Also check for bot messages  ///  Make sure users aren't sliding in bot dm's
        if msg.content.hasPrefix(">")  {   /// Check for prefix before running rest of conditionals
        
        }
    }
}


///Helper Functions Follow

func addGuildToClientele(guild: Guild) {
    manager[guild.id.hashValue] = CinemaClerk()
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

bot.connect()
bot.editStatus(to: "online", watching: ">help")

