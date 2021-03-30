//
//  Transformer.swift
//  Transformers
//
//  Created by Alek Spitzer on 3/27/21.
//

import Foundation


struct Transformer: Codable, Hashable {
    let id: String,
        name: String,
        strength: Int,
        intelligence: Int,
        speed: Int,
        endurance: Int,
        rank: Int,
        courage: Int,
        firepower: Int,
        skill: Int,
        team: String,
        teamIcon: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case strength
        case intelligence
        case speed
        case endurance
        case rank
        case courage
        case firepower
        case skill
        case team
        case teamIcon = "team_icon"
    }
        
}
