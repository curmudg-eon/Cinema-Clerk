//
//  File.swift
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
    func idOfLocation() -> Int {
        if self.channel.type == .guildText {
            return (self.channel as! GuildChannel).guild!.id.hashValue
        } else if  self.channel.type == .groupDM {
            return self.channel.id.hashValue
        } else if self.channel.type == .dm {
            return self.author!.id.hashValue
        } else {
            return 0
        }
    }
}
