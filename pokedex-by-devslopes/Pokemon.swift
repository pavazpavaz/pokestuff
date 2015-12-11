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
    
    // data encapsulation
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    // getters
    
    // name can't be nil because it is initialized
    var name: String {
        
        return _name
    }
    
    // pokedexId can't be nil because it is initialized
    var pokedexId: Int {
        
        return _pokedexId
    }
    
    var description: String {
        
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String {
        
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId: String {
        
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: String {
        
        // the get is not needed
        
        get {
            if _nextEvolutionLvl == nil {
                _nextEvolutionLvl = ""
            }
            return _nextEvolutionLvl
        }
    }
    
    
    // initialization:
    
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
                
                // types is of type array of dictionaries (key: string, value: string)
                // accounting for the possibility that the pokemon object has no description whatsoever ("where" condition)
                if let descArr = dict["descriptions"] as? [Dictionary<String,String>] where descArr.count > 0 {
                    
                    // grab the url description and make another request and store the description
                    if let url = descArr[0]["resource_uri"] {
                        
                        // making another request using the url_base constant + the resource_uri
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON{ response in // closure that is called after the request is successful:
                            
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                
                                // do not confound key description that is a string with the array of dictionaries called descriptions
                                if let description = descDict["description"] as? String {
                                    
                                    // assign the fetched value to the Pokemon object property
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            
                            // call the func when the request is completed
                            completed()
                        }
                    }
                } else {
                    
                    // if there's no description
                    self._description = ""
                }
                
                // Evolutions. Show the images and the names
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0 {
                    
                    // the API only gives you 1 evo
                    if let to = evolutions[0]["to"] as? String {
                        
                        // do not include the MEGA evo's. not supported but API still gives us
                        if to.rangeOfString("mega") == nil {
                            
                            // extract the poke id from the uri
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                // take out everything from the resource_uri except the id no. that we'll use to fetch the respective name and picture:
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                // remove the last trailing slash, so in the end all we have is the id no.
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                // assign the id no. and get the name
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                // grab the level it will evo and assign it
                                if let lvl = evolutions[0]["level"] as? Int {
                                    
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                
                                // TESTING
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionTxt)
                                print(self._nextEvolutionLvl)
                                
                            }
                        }
                    }
                }
            }
        }
    }
}











