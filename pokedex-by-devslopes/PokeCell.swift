//
//  PokeCell.swift
//  pokedex-by-devslopes
//
//  Created by Pedro Albuquerque Vaz on 08/12/15.
//  Copyright © 2015 pdrvz. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    // store a pokemon object
    var pokemon: Pokemon!
    
    // set rounded corners
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    // func to assign stuff
    func configureCell(pokemon: Pokemon) {
        
        // get the pokemon object
        self.pokemon = pokemon
        // assign the label text
        nameLbl.text = self.pokemon.name.capitalizedString
        // assign the correct image accd to the Id number
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
