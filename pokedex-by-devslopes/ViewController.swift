//
//  ViewController.swift
//  pokedex-by-devslopes
//
//  Created by Pedro Albuquerque Vaz on 08/12/15.
//  Copyright © 2015 pdrvz. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // connect the collectionview
    @IBOutlet weak var collection: UICollectionView!
    
    // storage for Pokemon objects
    var pokemon = [Pokemon]()
    
    // audio player (don't forget to import AVFoundation)
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this vc will be the delegate and dataSource for the instantiated collectionview
        collection.delegate = self
        collection.dataSource = self
        
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
            var poke = pokemon[indexPath.row]
            // populate its cell
            cell.configureCell(poke)
            return cell
            
        } else {
            
            // if it fails return a new generic cell
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    // number of items
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 718
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
    
}

