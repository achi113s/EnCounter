//
//  PokeAPIManager.swift
//  EnCounter
//
//  Created by Giorgio Latour on 3/26/23.
//

import Foundation


protocol PokeAPIManagerDelegate {
    func didFetchPokemon(_ pokeAPIManager: PokeAPIManager, pokemon: PokeAPIPokemonModel)
    func didFailWithError(error: Error)
}

struct PokeAPIManager {
    let pokeAPIUrl = "https://pokeapi.co/api/v2/pokemon-species/"
    
    var delegate: PokeAPIManagerDelegate?
    
    func fetchPokemon(withName name: String) {
        let urlString = "\(pokeAPIUrl)\(name)/"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let pokemon = self.parseJSON(safeData) {
                        self.delegate?.didFetchPokemon(self, pokemon: pokemon)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ pokeAPIData: Data) -> PokeAPIPokemonModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PokeAPIData.self, from: pokeAPIData)
            let id = decodedData.pokedex_numbers[0].entry_number
            let name = decodedData.name
            let desc = decodedData.flavor_text_entries[0].flavor_text.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "\u{0C}", with: " ")
            let genus = decodedData.genera[7].genus
            
            let pokemon = PokeAPIPokemonModel(pokemonID: id, pokemonName: name, pokemonDescription: desc, genus: genus)
            return pokemon
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
