//
//  Constants.swift
//  pokedex-by-devslopes
//
//  Created by Pedro Albuquerque Vaz on 11/12/15.
//  Copyright © 2015 pdrvz. All rights reserved.
//

import Foundation

// constants file holds constants that are globally accessible (it is recommended to use one):

let URL_BASE = "http://pokeapi.co"

let URL_POKEMON = "/api/v1/pokemon/"

// the complete URL in the Pokemon Model init will be BASE + POKEOMON + (the id number of that pokemon)


// defining our own custom closure (taking care of the async characteristic of downloading data from the web). When the download is complete someone could call this closure
typealias DownloadComplete = () -> ()