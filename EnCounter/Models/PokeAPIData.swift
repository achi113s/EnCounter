//
//  PokeAPIData.swift
//  EnCounter
//
//  Created by Giorgio Latour on 3/26/23.
//

import Foundation

struct PokeAPIData: Codable {
    let name: String
    let pokedex_numbers: [PokedexNumber]
    let genera: [Genus]
    let flavor_text_entries: [Flavor]
}

struct PokedexNumber: Codable {
    let entry_number: Int
    let pokedex: Pokedex
}

struct Pokedex: Codable {
    let name: String
    let url: String
}

struct Genus: Codable {
    let genus: String
    let language: Language
}

struct Language: Codable {
    let name: String
    let url: String
}

struct Flavor: Codable {
    let flavor_text: String
    let language: Language
    let version: GameVersion
}

struct GameVersion: Codable {
    let name: String
    let url: String
}

