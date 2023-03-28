//
//  ViewController.swift
//  EnCounter
//
//  Created by Giorgio Latour on 3/25/23.
//

import UIKit
import CoreData

class HuntsViewController: UITableViewController {
    
    var hunts = [Hunt]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.huntCellNibName, bundle: nil), forCellReuseIdentifier: K.huntCellIdentifier)
        loadHunts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hunts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hunt = hunts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.huntCellIdentifier, for: indexPath) as! HuntCell
        
        cell.pokemonNameLabel.text = hunt.pokemonName
        cell.pokemonIDLabel.text = String(hunt.pokemonID)
        cell.spriteImageView.image = UIImage(named: String(hunt.pokemonID))
        cell.encounterCountLabel.text = String(hunt.encounterCount)
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.SegueNames.goToHuntSummary, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueNames.goToHuntSummary {
            let destinationVC = segue.destination as! HuntSummaryViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedHunt = hunts[indexPath.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, sourceView, completionHandler in
            let huntPredicate = NSPredicate(format: "\(K.CoreDataConst.huntUUIDField) == %@", self.hunts[indexPath.row].huntID! as CVarArg)
            
            let request = Hunt.fetchRequest()
            request.predicate = huntPredicate
            
            var huntsToDelete = [Hunt]()
            
            do {
                huntsToDelete = try self.context.fetch(request)
                self.hunts.remove(at: indexPath.row)
            } catch {
                print("Error fetching data from context, \(error).")
                completionHandler(false)
            }
            
            for hunt in huntsToDelete {
                self.context.delete(hunt)
            }
            
            self.saveHunts()
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    //MARK: - Data Manipulation Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.SegueNames.goToPokemonList, sender: self)
    }
    
    func saveHunts() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadHunts(with request: NSFetchRequest<Hunt> = Hunt.fetchRequest()) {
        do {
            hunts = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
    }
    
}
