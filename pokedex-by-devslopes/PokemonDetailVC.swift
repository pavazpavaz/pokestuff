//
//  PokemonDetailVC.swift
//  pokedex-by-devslopes
//
//  Created by Pedro Albuquerque Vaz on 09/12/15.
//  Copyright © 2015 pdrvz. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    // IBOutlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var baseAttkLbl: UILabel!
    @IBOutlet weak var currentEvoLbl: UIImageView!
    @IBOutlet weak var nextEvoLbl: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    // it will store the clicked pokemon
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // populate name lbl
        nameLbl.text = pokemon.name
        // fetch respective picture
        mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
        
        // get the other info from the poke api
        pokemon.downloadPokemonDetails { () -> () in
            
            // this will be called after the download is done
        }
    }

    @IBAction func onBackBtnPressed(sender: AnyObject) {
        
        // dismiss this vc
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
