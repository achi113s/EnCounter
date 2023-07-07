//
//  PokemonSummaryViewController.swift
//  EnCounter
//
//  Created by Giorgio Latour on 3/25/23.
//

import UIKit
import CoreData

class PokemonSummaryViewController: UIViewController {
    
    @IBOutlet weak var spriteImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonGenusLabel: UILabel!
    @IBOutlet weak var pokemonDescLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedPokemon: Pokemon?
    var pokeAPIManager: PokeAPIManager = PokeAPIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        if let pokemon = selectedPokemon {
            spriteImageView.image = UIImage(named: String(pokemon.pokemonID))
            pokemonNameLabel.text = "\(pokemon.pokemonID). \(pokemon.pokemonName ?? "None")"
            title = pokemon.pokemonName ?? "Pokemon"
            pokemonGenusLabel.text = ""
            pokemonDescLabel.text = ""
            
            pokeAPIManager.delegate = self
            if let safeName = pokemon.pokemonName?.lowercased() {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.pokeAPIManager.fetchPokemon(withName: safeName)
                }
            }
        }
    }
    
    //MARK: - CoreData Manipulation Methods
    
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        guard let pokemonToAdd = selectedPokemon else {
            return
        }
        
        if let huntsVC = navigationController?.viewControllers.first as? HuntsViewController {
            let newHunt = Hunt(context: context)
            newHunt.encounterCount = 0
            newHunt.pokemonID = pokemonToAdd.pokemonID
            newHunt.pokemonName = pokemonToAdd.pokemonName
            newHunt.huntID = UUID()
            newHunt.startDate = Date()
            
            saveContext(context)
            
            huntsVC.hunts.append(newHunt)
            huntsVC.tableView.reloadData()
            
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

//MARK: - PokeAPIManagerDelegate

extension PokemonSummaryViewController: PokeAPIManagerDelegate {
    func didFetchPokemon(_ pokeAPIManager: PokeAPIManager, pokemon: PokeAPIPokemonModel) {
        DispatchQueue.main.async {
            self.pokemonGenusLabel.text = pokemon.genus
            self.pokemonDescLabel.text = pokemon.pokemonDescription
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
