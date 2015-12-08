//
//  Pokemon.swift
//  pokedex-by-devslopes
//
//  Created by Pedro Albuquerque Vaz on 08/12/15.
//  Copyright © 2015 pdrvz. All rights reserved.
//

import Foundation

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    
    var name: String {
        
        return _name
    }
    
    var pokedexId: Int {
        
        return _pokedexId
    }
    
    init (name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
    }
}