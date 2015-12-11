//
//  Pokemon.swift
//  pokedex-by-devslopes
//
//  Created by Pedro Albuquerque Vaz on 08/12/15.
//  Copyright © 2015 pdrvz. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonUrl: String!
    
    var name: String {
        
        return _name
    }
    
    var pokedexId: Int {
        
        return _pokedexId
    }
    
    init (name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
        
        // create the pokemon api url for this specific pokemon
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    // using AlamoFire to download the info from the net
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        // we need to account for the fact that downloading is an async process. For that reason we pass a Closure as a parameter -- a Closure in swift is like a callback, useful to handle async processes. When the download is complete the closure is called, not before. Closures are code that can be run at a later time (waiting for async processes to finish)
        let url = NSURL(string: _pokemonUrl)!
        // after getting the request is run, run this block of code (closure)
        Alamofire.request(.GET, url).responseJSON{ (response) -> Void in
            
            // when the data arrives, parse it
            // 1. convert the json into a dictionary
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                // 2. grab the fields we want out of the dict
                if let weight = dict["weight"] as? String {
                    
                    // 3. assign to the Object property
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    
                    // 3. assign to the Object property
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    
                    // 3. assign to the Object property
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    
                    // 3. assign to the Object property
                    self._defense = "\(defense)"
                }
                
                // TESTING
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                // types is of type array of dictionaries (key: string, value: string)
                // accounting for the possibility that the pokemon object has no type whatsoever ("where" condition)
                if let types = dict["types"] as? [Dictionary<String,String>] where types.count > 0 {
                    
                    // grab the first item (dict) of the array for key name
                    if let name = types[0]["name"] {
                        
                        // assign to the Object property
                        self._type = name.capitalizedString
                    }
                    
                    // if the pokemon has more than 1 type
                    if types.count > 1 {
                        
                        for var x = 1; x < types.count; x++ {
                            
                            // grab the value for key name for every dict in the array
                            if let name = types[x]["name"] {
                                
                                // assign it to the Object property with a special formatting
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    
                    // if there are no types
                    self._type = ""
                }
                
                print(self._type)
            }
        }
    }
}


