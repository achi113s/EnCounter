//
//  HuntSummaryViewController.swift
//  EnCounter
//
//  Created by Giorgio Latour on 3/25/23.
//

import UIKit
import CoreData

class HuntSummaryViewController: UIViewController {
    
    @IBOutlet weak var spriteImageView: UIImageView!
    @IBOutlet weak var pokemonIDLabel: UILabel!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonEncounterCountLabel: UILabel!
    @IBOutlet weak var encounterCountStepper: UIStepper!
    @IBOutlet weak var dateLabel: UILabel!
    
    var selectedHunt: Hunt?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let hunt = selectedHunt {
            spriteImageView.image = UIImage(named: String(hunt.pokemonID))
            pokemonIDLabel.text = String(hunt.pokemonID)
            pokemonNameLabel.text = hunt.pokemonName
            pokemonEncounterCountLabel.text = String(hunt.encounterCount)
            encounterCountStepper.value = Double(hunt.encounterCount)
            dateLabel.text = hunt.startDate?.formatted() ?? "01/01/2099"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let huntsVC = navigationController?.viewControllers.first as? HuntsViewController {
            huntsVC.tableView.reloadData()
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
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        if let hunt = selectedHunt {
            let newStepperValue: Int32 = Int32(encounterCountStepper.value)
            hunt.encounterCount = newStepperValue
            pokemonEncounterCountLabel.text = String(newStepperValue)
            
            saveContext(context)
        }
    }
}
