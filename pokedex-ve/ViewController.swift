//
//  ViewController.swift
//  pokedex-ve
//
//  Created by rahman on 9/28/15.
//  Copyright © 2015 VE. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var pokemon = [Pokemon]() //empty pokemon array
    var filteredPokemon = [Pokemon]()
    var musicPlayer : AVAudioPlayer!
    
    var isSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionview.dataSource = self
        collectionview.delegate = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        initAudio()
        parsePokemonCSV()
        
    }
    
    func initAudio(){
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do{
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }

    func parsePokemonCSV(){
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            //print(rows)
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let pokeName = row["identifier"]!
                
                let poke = Pokemon(name: pokeName, pokedexId: pokeId)
                
                pokemon.append(poke)
                
            }
            
        }catch let err as NSError {
            print(err.debugDescription)
        }
    }
    

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchMode ? filteredPokemon.count : pokemon.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCellCollectionViewCell {
            
            let poke = isSearchMode ? filteredPokemon[indexPath.row] : pokemon[indexPath.row]
            
            cell.configureCell(poke)
            
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let poke: Pokemon = isSearchMode ? filteredPokemon[indexPath.row] : pokemon[indexPath.row]
        
        performSegueWithIdentifier("PokemonDetailSegue", sender: poke)
        
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            isSearchMode = false
            view.endEditing(true)
        }else{
            isSearchMode = true
            let lowerSearchText = searchBar.text!.lowercaseString
            
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lowerSearchText) != nil })
        }
        collectionview.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PokemonDetailSegue" {
            if let detailVC = segue.destinationViewController as? PokemonDetailViewController {
                if let poke = sender as? Pokemon {
                    detailVC.pokemon = poke
                }
            }
        }
    }
    
    @IBAction func btnMusicPressed(sender: UIButton!) {
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
        }else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }

}

