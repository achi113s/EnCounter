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
    @IBOutlet weak var pokemonIDLabel: UILabel!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedPokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pokemon = selectedPokemon {
            spriteImageView.image = UIImage(named: String(pokemon.pokemonID))
            pokemonIDLabel.text = String(pokemon.pokemonID)
            pokemonNameLabel.text = pokemon.pokemonName
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
