//
//  PokemonListViewController.swift
//  EnCounter
//
//  Created by Giorgio Latour on 3/25/23.
//

import UIKit
import CoreData

class PokemonListViewController: UITableViewController, UISearchBarDelegate {

    var pokemonArray = [Pokemon]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: K.pokemonCellNibName, bundle: nil), forCellReuseIdentifier: K.pokemonCellIdentifier)
        tableView.tableHeaderView = searchBar
        searchBar.delegate = self
        
        
        loadPokemon()
    }
    
    //MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon = pokemonArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.pokemonCellIdentifier, for: indexPath) as! PokemonCell
        
        cell.pokemonNameLabel.text = pokemon.pokemonName
        cell.pokemonIDLabel.text = String(pokemon.pokemonID)
        cell.spriteImageView.image = UIImage(named: String(pokemon.pokemonID))
        
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.SegueNames.goToPokemonSummary, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueNames.goToPokemonSummary {
            let destinationVC = segue.destination as! PokemonSummaryViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedPokemon = pokemonArray[indexPath.row]
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    //MARK: - CoreData Manipulation Methods
    
    func loadPokemon(with request: NSFetchRequest<Pokemon> = Pokemon.fetchRequest(), predicate: NSPredicate? = nil) {
        // If a predicate was passed in, we need to filter the fetched results.
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do {
            pokemonArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
    }
    
    //MARK: - Search Bar Delegate Methods

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count != 0 {
            let request: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
            
            let searchPredicate = NSPredicate(format: "\(K.CoreDataConst.pokemonPokemonNameField) CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: K.CoreDataConst.pokemonPokemonIDField, ascending: true)]
            
            loadPokemon(with: request, predicate: searchPredicate)
        } else {
            loadPokemon()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        tableView.reloadData()
    }
}

