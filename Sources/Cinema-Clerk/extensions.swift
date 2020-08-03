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
    func idOfLocation() -> UInt64 {
        if self.channel.type == .guildText {
            return (self.channel as! GuildChannel).guild!.id.rawValue
        } else if  self.channel.type == .groupDM {
            return self.channel.id.rawValue
        } else if self.channel.type == .dm {
            return self.author!.id.rawValue
        } else {
            return 0
        }
    }
}
