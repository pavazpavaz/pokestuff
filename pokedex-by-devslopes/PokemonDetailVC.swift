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
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    // it will store the clicked pokemon
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // populate name lbl
        nameLbl.text = pokemon.name
        // fetch respective img
        var img = UIImage(named: "\(pokemon.pokedexId)")
        // assign img
        mainImg.image = img
        // current Evo is the same img as the main one
        currentEvoImg.image = img
        
        // get the other info from the poke api
        pokemon.downloadPokemonDetails { () -> () in
            
            // this will be called after the download is done
            self.updateUI()
        }
    }

    // func to update stuff with the data downloaded from the api
    func updateUI() {
        
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        pokedexLbl.text = "\(pokemon.pokedexId)"
        weightLbl.text = pokemon.weight
        baseAttkLbl.text = pokemon.attack
        
        // if the pokemon has no evolutions, change lbl text and hide img
        if pokemon.nextEvolutionId == "" {
            
            evoLbl.text = "No Evolutions"
            nextEvoImg.hidden = true
        } else {
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            
            // if pokemon has evo lvl, format a dash LVL
            if pokemon.nextEvolutionLvl != "" {
                
                str += " - LVL \(pokemon.nextEvolutionLvl)"
            }
        }
    }
    
    @IBAction func onBackBtnPressed(sender: AnyObject) {
        
        // dismiss this vc
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
