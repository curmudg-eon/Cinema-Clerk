//
//  extension.swift
//  
//
//  Created by Gabe Secula on 6/19/20.
//
import Sword
import Foundation

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.lowercased().hasPrefix(prefix.lowercased()) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

//!!! Add a getGuildFromMessage extension !!!!
extension Message {
    func idOfLocation() -> UInt64 {//maybe make this an optional? Will wait and see how often there are failures in message reciept- right now it seems like never
        if self.channel.type == .guildText {
            return (self.channel as! GuildChannel).guild!.id.rawValue
        } else if  self.channel.type == .groupDM {
            return self.channel.id.rawValue
        } else if self.channel.type == .dm {
            if let id = self.author?.id.rawValue {
                return id
            } else {
                self.reply(with: "I am unable to interact with bots.")
                return 0
            }
        } else { //API should never send a message from a voice channel or text channel
            self.reply(with: "Your message is addressed from a voice channel or category and I am unable to respond.")
            return 0
        }
    }
}

extension Snowflake {
    init (_ id: Int) {
        self.init(UInt64(id))
    }
}
