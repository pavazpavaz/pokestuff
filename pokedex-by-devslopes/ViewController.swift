//
//  ViewController.swift
//  pokedex-by-devslopes
//
//  Created by Pedro Albuquerque Vaz on 08/12/15.
//  Copyright © 2015 pdrvz. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    // connect the collectionview
    @IBOutlet weak var collection: UICollectionView!
    
    // connect the searchbar
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // storage for Pokemon objects
    var pokemon = [Pokemon]()
    
    // secondary storage array for the filtered search results
    var filteredPokemon = [Pokemon]()
    
    // audio player (don't forget to import AVFoundation)
    var musicPlayer: AVAudioPlayer!
    
    // boolean to detect and switch between full poke array and filtered secondary one
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this vc will be the delegate and dataSource for the instantiated collectionview
        collection.delegate = self
        collection.dataSource = self
        
        // this vc will be the delegate for the searchbar
        searchBar.delegate = self
        
        // use Done keyword on the kb instead of Search
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        initAudio()
        parsePokemonCSV()
    }
    
    func initAudio() {
        
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            // infinite loop
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }
    
    // func to parse the 718 pokemons
    func parsePokemonCSV() {
        
        // grab the file at resources that lists all pokemon and their ids
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        // run the parser
        do {
            
            let csv = try CSV(contentsOfURL: path)
            // grab the rows out of the CSV file
            let rows = csv.rows
            
            // create the pokemon objects and put them in the storage array
            // each row in the csv file is an array of dictionaries for each pokemon
            // we grab the id and convert it into an integer so then we can use that id to get the rigth picture and name for the label
            for row in rows {
                
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                // create the pokemon
                let poke = Pokemon(name: name, pokedexId: pokeId)
                // store the pokemon in the storage array
                pokemon.append(poke)
            }
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }

    // to work with the collection view we need to implement the protocols: collectionviewdelegate, collectionviewdatasource and collectionviewdelegateflowlayout
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // just like a tableview, a collectionview reuses the cell (don't forget to set the identifier in the main storyboard cell)
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            
            // grab the pokemon
            let poke: Pokemon!
            
            // if in searchmode use filtered array, if not use complete array
            if inSearchMode {
                
                poke = filteredPokemon[indexPath.row]
            } else {
                
                poke = pokemon[indexPath.row]
            }
            // populate its cell
            cell.configureCell(poke)
            return cell
            
        } else {
            
            // if it fails return a new generic cell
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // whenever an icon is tapped, grab that item from the right array and pass it do the detailVC
        let poke: Pokemon!
        
        if inSearchMode {
            
            poke = filteredPokemon[indexPath.row]
        } else {
            
            poke = pokemon[indexPath.row]
        }
        
        // debug printing
        print(poke.name)
        
        // segue to DetailVC with the item that was clicked
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
    }
    
    // number of items
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // if in searchmode use filtered array, if not use complete array
        if inSearchMode {
            
            return filteredPokemon.count
        }
            
        return pokemon.count
    }
    
    //
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    // set the size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(105, 105)
    }
    
    @IBAction func onMusicBtnPressed(sender: UIButton!) {
        
        if musicPlayer.playing {
            
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    // funcs for the searchbar
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        // when press hide the kb
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // if there's no text in the search bar
        if searchBar.text == nil || searchBar.text == "" {
            
            // use full poke list array
            inSearchMode = false
            // if it is empty end the editing --- take away the kb
            view.endEditing(true)
            collection.reloadData()
        } else {
            
            // change to filtered array
            inSearchMode = true
            // grab the word that's in the textbar
            let lower = searchBar.text!.lowercaseString
            // closure expression. $0 is used as a var to grab an element out of the array
            // see if there's a string on it and finds and return if the name contains our string in every single one of the pokemons. If it exists (not nil) add it to our filtered array
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            // refresh our collectionview with the new filteredPokemon array
            collection.reloadData()
        }
    }
    
    // prepare the clicked item info to be picked up by the detailVC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PokemonDetailVC" {
            
            // grab the destinationVC (detailVC)
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                
                // grab the pokemon item (sent by performsegue above) and cast it as a Pokemon object
                if let poke = sender as? Pokemon {
                    
                    // assign it as the pokemon on the detailsVC
                    detailsVC.pokemon = poke
                }
            }
        }
    }
}

