import Sword

let bot = Sword(token: Token) //Replace Token with your bot's token string 

bot.editStatus(to: "online", watching: ">help")

bot.on(.messageCreate) { data in
  let msg = data as! Message

  if msg.content == ">ping" {
    msg.reply(with: "Pong!")
  }
}

bot.connect()
