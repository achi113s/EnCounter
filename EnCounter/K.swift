//
//  K.swift
//  EnCounter
//
//  Created by Giorgio Latour on 3/25/23.
//

import Foundation

struct K {
    static let huntCellIdentifier: String = "ReusableHuntCell"
    static let huntCellNibName: String = "HuntCell"
    static let pokemonCellIdentifier: String = "ReusablePokemonCell"
    static let pokemonCellNibName: String = "PokemonCell"
    
    struct SegueNames {
        static let goToPokemonList: String = "goToPokemonList"
        static let goToPokemonSummary: String = "goToPokemonSummary"
        static let goToHuntSummary: String = "goToHuntSummary"
    }
    
    struct CoreDataConst {
        static let huntUUIDField: String = "huntID"
        static let huntPokemonNameField: String = "pokemonName"
        static let huntPokemonIDField: String = "pokemonID"
        static let huntEncounterCountField: String = "encounterCount"
        
        static let pokemonPokemonNameField: String = "pokemonName"
        static let pokemonPokemonIDField: String = "pokemonID"
    }
}
