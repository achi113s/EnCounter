//
//  HuntCell.swift
//  EnCounter
//
//  Created by Giorgio Latour on 3/25/23.
//

import UIKit

class HuntCell: UITableViewCell {

    @IBOutlet weak var pokemonIDLabel: UILabel!
    @IBOutlet weak var spriteImageView: UIImageView!
    @IBOutlet weak var encounterCountLabel: UILabel!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
