//
//  HuntSummaryViewController.swift
//  EnCounter
//
//  Created by Giorgio Latour on 3/25/23.
//

import UIKit

class HuntSummaryViewController: UIViewController {
    
    @IBOutlet weak var spriteImageView: UIImageView!
    @IBOutlet weak var pokemonIDLabel: UILabel!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonEncounterCountLabel: UILabel!
    @IBOutlet weak var encounterCountStepper: UIStepper!
    
    var selectedHunt: Hunt?
    
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
        }
    }
}
