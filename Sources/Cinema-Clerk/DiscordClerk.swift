//
//  File.swift
//  
//
//  Created by Gabe Secula on 7/11/20.
//

import Foundation
import Sword

class DiscordClerk: CinemaClerk {
    
    var textChannel: GuildText?
    
    init(guild: Guild) {
        let guild: Guild = guild
        let id: Int = guild.id.hashValue
    }
    
    func setTextChannel (textChl: GuildText) {
        textChannel = textChl
    }
    
    
}

